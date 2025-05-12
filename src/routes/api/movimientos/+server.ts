import { PrismaClient } from '@prisma/client';
import { json } from '@sveltejs/kit';

const prisma = new PrismaClient();

export async function POST({ request }) {
    try {
        const data = await request.json();

        // Validar campos requeridos para el movimiento
        if (!data.id_producto || !data.id_almacen || !data.costo || !data.stock) {
            return json({ error: 'Faltan datos requeridos para el movimiento de inventario.' }, { status: 400 });
        }

        const nuevoMovimiento = await prisma.movimientoInventario.create({
            data: {
                id_producto: data.id_producto,
                id_almacen: data.id_almacen,
                fecha: new Date(), // Fecha y hora actual
                tipo: 'ENTRADA',    // Tipo de movimiento: ENTRADA
                cantidad: data.stock, // Cantidad del stock
                existencia_antes: 0, // Existencia anterior: 0 para la creación inicial
                costo: data.costo,
                referencia: data.id_entrada ,   // Usar el ID de entrada
            }
        });

        return json(nuevoMovimiento, { status: 201 });
    } catch (error) {
        console.error('Error al crear movimiento de inventario:', error);
        return json({ error: 'Error al crear movimiento de inventario', detalle: error.message }, { status: 500 });
    }
}
