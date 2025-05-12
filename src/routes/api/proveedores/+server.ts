import { PrismaClient } from '@prisma/client';
import { json } from '@sveltejs/kit';

const prisma = new PrismaClient();

export async function GET() {
    try {
        const proveedores = await prisma.proveedor.findMany({
            orderBy: { nombre: 'asc' }
        });
        return json(proveedores);
    } catch (error) {
        console.error('Error al obtener proveedores:', error);
        return json(
            { error: 'Error al obtener los proveedores', detalle: error.message },
            { status: 500 }
        );
    }
}

export async function POST({ request }) {
    try {
        const data = await request.json();
        // Validar campos requeridos
        if (!data.nombre) {
            return json(
                { error: 'Nombre es un campo obligatorio' },
                { status: 400 }
            );
        }

        const proveedor = await prisma.proveedor.create({
            data: {
                nombre: data.nombre,
            }
        });

        return json(proveedor, { status: 201 });
    } catch (error) {
        console.error('Error al crear proveedor:', error);

        if (error.code === 'P2002') {
            return json(
                { error: 'El nombre ya está registrado' },
                { status: 400 }
            );
        }

        return json(
            { error: 'Error al crear el proveedor', detalle: error.message },
            { status: 500 }
        );
    }
}
