import { PrismaClient } from '@prisma/client';
import { json } from '@sveltejs/kit';

const prisma = new PrismaClient();

export async function GET() {
    try {
        const categorias = await prisma.categoria.findMany({
            orderBy: { nombre: 'asc' } // Ordenar las categorías por nombre
        });
        return json(categorias);
    } catch (error) {
        console.error('Error al obtener categorías:', error);
        return json(
            { error: 'Error al obtener las categorías', detalle: error.message },
            { status: 500 }
        );
    }
}

export async function POST({ request }) {
    try {
        const { nombre } = await request.json();

        if (!nombre) {
            return json({ error: 'El nombre de la categoría es obligatorio' }, { status: 400 });
        }

        const categoria = await prisma.categoria.create({
            data: { nombre }
        });

        return json(categoria, { status: 201 });
    } catch (error) {
        console.error('Error al crear categoría:', error);
        return json(
            { error: 'Error al crear la categoría', detalle: error.message },
            { status: 500 }
        );
    }
}
