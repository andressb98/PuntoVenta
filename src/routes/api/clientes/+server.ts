import { PrismaClient } from '@prisma/client';
import { json, type RequestHandler } from '@sveltejs/kit';
const prisma = new PrismaClient();

export const GET: RequestHandler = async () => {
	try {
		const clientes = await prisma.cliente.findMany({
			include: {
				credito: true
			},
			orderBy: {
				nombre: 'asc'
			}
		});
		return json(clientes);
	} catch (error) {
		console.error('Error al obtener clientes:', error);
		return json({ error: 'Error al obtener clientes' }, { status: 500 });
	}
};

export const POST: RequestHandler = async ({ request }) => {
	try {
		const data = await request.json();

		if (!data.nombre || !data.domicilio || !data.telefono || !data.correo || !data.fecha_nacimiento) {
			return json({ error: 'Faltan campos obligatorios' }, { status: 400 });
		}

		const cliente = await prisma.cliente.create({
			data: {
				nombre: data.nombre,
				domicilio: data.domicilio,
				telefono: data.telefono,
				correo: data.correo,
				fecha_alta: new Date(data.fecha_alta || new Date()),
				fecha_nacimiento: new Date(data.fecha_nacimiento),
				comentarios: data.comentarios || '',
				referencias: data.referencias || '',
				usa_credito: data.usa_credito || false
			}
		});

		if (data.usa_credito && data.credito) {
			await prisma.credito.create({
				data: {
					id_cliente: cliente.id,
					credito_total: data.credito.credito_total,
					disponible: data.credito.credito_total,
					pagado: 0,
					saldo: 0,
					estatus: data.credito.estatus || 'ACTIVO'
				}
			});
		}

		const result = await prisma.cliente.findUnique({
			where: { id: cliente.id },
			include: { credito: true }
		});

		return json(result, { status: 201 });
	} catch (error) {
		console.error('Error al crear cliente:', error);
		return json({ error: 'Error al crear cliente' }, { status: 500 });
	}
};
