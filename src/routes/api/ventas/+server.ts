import { PrismaClient } from '@prisma/client';
import { json } from '@sveltejs/kit';

const prisma = new PrismaClient();

export async function POST({ request }) {
    try {
        const data = await request.json();

        // Validar campos requeridos de la venta
        if (!data.id_usuario || !data.id_sucursal || !data.total || !data.fecha || !data.productos || data.productos.length === 0) {
            return json({ error: 'Faltan campos obligatorios para la venta' }, { status: 400 });
        }

        // Iniciar la transacción
        const ventaConDetalles = await prisma.$transaction(async (tx) => {
            // Crear la venta
            const nuevaVenta = await tx.venta.create({
                data: {
                    id_cliente: data.id_cliente || null,
                    id_vendedor: data.id_vendedor || null,
                    id_corte: data.id_corte || null,
                    id_sucursal: data.id_sucursal,
                    id_usuario: data.id_usuario,
                    total: data.total,
                    fecha_hora: new Date(data.fecha),
                    descuento: data.descuento || 0,
                    subtotal: data.subtotal || data.total,
                    impuestos: data.impuestos || 0,
                    estatus: 'Pendiente',
                    id_forma_pago: data.id_forma_pago || null,
                    saldo_deber: data.saldo_deber || 0,
                    abono: data.abono || 0,
                    cambio: data.cambio || 0,
                    comentarios: data.comentarios || null,
                },
            });

            const detallesVentaConProducto = await Promise.all(
                data.productos.map(async (producto) => {
                    const detalle = await tx.detalleVenta.create({
                        data: {
                            id_venta: nuevaVenta.id,
                            id_producto: producto.id_producto,
                            cantidad: producto.cantidad,
                            precio: producto.precio_unitario,
                            descuento: producto.descuento || 0,
                        },
                        include: {
                            producto: true,
                        },
                    });

                    // Actualizar el stock del producto
                    await tx.producto.update({
                        where: { id: producto.id_producto },
                        data: { stock: { decrement: producto.cantidad } },
                    });

                    return detalle;
                })
            );

            return { venta: nuevaVenta, detalles: detallesVentaConProducto };
        });

        return json(ventaConDetalles, { status: 201 });
    } catch (error) {
        console.error('Error al crear la venta y actualizar el stock:', error);
        return json(
            { error: 'Error al crear la venta y actualizar el stock', detalle: error.message },
            { status: 500 }
        );
    } finally {
        await prisma.$disconnect();
    }
}