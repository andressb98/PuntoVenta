import { PrismaClient } from '@prisma/client';
import { json } from '@sveltejs/kit';

const prisma = new PrismaClient();

export async function GET() {
	try {
		const productos = await prisma.producto.findMany({
			include: {
				categoria: true // Incluir la categoría para obtener el nombre
			},
			orderBy: {
				codigo: 'asc'
			}
		});
		// Transformar los datos para que coincidan con la estructura que espera el componente Svelte
		const productosConNombreCategoria = productos.map((producto) => ({
			...producto,
			nombre: producto.categoria.nombre // Agregar el nombre de la categoría
		}));
		return json(productosConNombreCategoria);
	} catch (error) {
		console.error('Error al obtener productos:', error);
		return json(
			{ error: 'Error al obtener los productos', detalle: error.message },
			{ status: 500 }
		);
	}
}

export async function POST({ request }) {
	try {
		const data = await request.json();

		// Validar campos requeridos
		if (
			!data.codigo ||
			!data.descripcion ||
			!data.precio ||
			!data.costo ||
			!data.id_categoria ||
			!data.id_almacen ||
			!data.stock ||
			!data.unidad
		) {
			return json({ error: 'Todos los campos requeridos deben ser completados' }, { status: 400 });
		}

		const producto = await prisma.producto.create({
			data: {
				codigo: data.codigo,
				descripcion: data.descripcion,
				precio: data.precio,
				costo: data.costo,
				iva: data.iva,
				id_categoria: data.id_categoria,
				id_almacen: data.id_almacen,
				stock: data.stock,
				unidad: data.unidad,
				precio_mayoreo: data.precio_mayoreo || null,
				modelo: data.modelo || null,
				stock_minimo: data.stock_minimo || null
			}
		});

		// Devolver el producto creado, que incluye el ID
		return json(producto, { status: 201 });
	} catch (error) {
		console.error('Error al crear producto:', error);
		return json({ error: 'Error al crear el producto', detalle: error.message }, { status: 500 });
	}
}

