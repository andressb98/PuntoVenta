import { PrismaClient } from '@prisma/client';
import { json } from '@sveltejs/kit';

const prisma = new PrismaClient();

export async function GET() {
	try {
		const roles = await prisma.rol.findMany({
			select: { id: true, nombre: true }
		});
		return json({ roles });
	} catch (error) {
		console.error('Error al obtener roles:', error);
		return json({ error: 'No se pudieron cargar los roles.' }, { status: 500 });
	}
}
