import { PrismaClient } from '@prisma/client';
import { json } from '@sveltejs/kit';

const prisma = new PrismaClient();

export async function POST({ params, request }) {
    const id = parseInt(params.id);
    const { cantidad, tipo } = await request.json();

    if (!cantidad || cantidad <= 0) {
        return json({ error: 'La cantidad debe ser mayor que cero' }, { status: 400 });
    }

    try {
        const producto = await prisma.producto.findUnique({
            where: { id },
        });

        if (!producto) {
            return json({ error: 'Producto no encontrado' }, { status: 404 });
        }

        if (tipo === 'salida' && producto.stock < cantidad) {
            return json({ error: 'Stock insuficiente' }, { status: 400 });
        }

        const nuevoStock = tipo === 'entrada' ? producto.stock + cantidad : producto.stock - cantidad;

        const updatedProducto = await prisma.producto.update({
            where: { id },
            data: {
                stock: nuevoStock,
                movimientos: {
                    create: {
                        cantidad,
                        tipo,
                        fecha: new Date(),
                    },
                },
            },
        });

        return json(updatedProducto);
    } catch (error) {
        console.error(`Error al procesar ${tipo} de inventario:`, error);
        return json(
            { error: `Error al procesar ${tipo} de inventario`, detalle: error.message },
            { status: 500 }
        );
    }
}
