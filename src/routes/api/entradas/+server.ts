import { PrismaClient } from '@prisma/client';
import { json } from '@sveltejs/kit';

const prisma = new PrismaClient();

export async function POST({ request }) {
    try {
        const data = await request.json();

        // Validar campos requeridos para la entrada
        if (!data.id_almacen || !data.importe || !data.observaciones || !data.id_usuario) {
            return json({ error: 'Faltan datos requeridos para la entrada.' }, { status: 400 });
        }

        const nuevaEntrada = await prisma.entrada.create({
            data: {
                fecha_emision: new Date(),
                id_almacen: data.id_almacen,
                importe: data.importe,
                observaciones: data.observaciones,
                id_usuario: data.id_usuario,
            }
        });

        const entradaId = nuevaEntrada.id; // Obtener el ID de la entrada creada

        return json({ ...nuevaEntrada, id: entradaId }, { status: 201 }); // Devolver el ID
    } catch (error) {
        console.error('Error al crear entrada:', error);
        return json({ error: 'Error al crear entrada', detalle: error.message }, { status: 500 });
    }
}
