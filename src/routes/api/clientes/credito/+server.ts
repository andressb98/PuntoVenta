import { PrismaClient } from '@prisma/client';
import { json, type RequestHandler } from '@sveltejs/kit';
const prisma = new PrismaClient();


export const POST: RequestHandler = async ({ request }) => {
	try {
		const data = await request.json();

		if (!data.id_cliente || !data.credito_total) {
			return json({ error: 'Faltan campos obligatorios' }, { status: 400 });
		}

		const cliente = await prisma.cliente.findUnique({
			where: { id: data.id_cliente }
		});

		if (!cliente) {
			return json({ error: 'Cliente no encontrado' }, { status: 404 });
		}

		const credito = await prisma.credito.upsert({
			where: { id_cliente: data.id_cliente },
			update: {
				credito_total: data.credito_total,
				disponible: data.disponible ?? data.credito_total,
				estatus: data.estatus || 'ACTIVO'
			},
			create: {
				id_cliente: data.id_cliente,
				credito_total: data.credito_total,
				disponible: data.credito_total,
				pagado: 0,
				saldo: 0,
				estatus: data.estatus || 'ACTIVO'
			}
		});

		await prisma.cliente.update({
			where: { id: data.id_cliente },
			data: { usa_credito: true }
		});

		return json(credito);
	} catch (error) {
		console.error('Error al manejar crédito:', error);
		return json({ error: 'Error al manejar crédito' }, { status: 500 });
	}
};
