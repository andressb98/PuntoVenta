<script lang="ts">
	import { onMount } from 'svelte';

	type Producto = {
		id: number;
		codigo: string;
		descripcion: string;
		precio: number;
		precio_mayoreo: number;
		costo: number;
		iva: number;
		id_categoria: number;
		stock: number;
		unidad: string;
		modelo: string;
		stock_minimo: number;
		categoria: {
			nombre: string;
		};
	};

	type Categoria = {
		id: number;
		nombre: string;
	};

	// Estado
	let productos: Producto[] = [];
	let categorias: Categoria[] = [];
	let isLoading = false;
	let error: string | null = null;

	// Filtros
	let filtro = '';
	let categoriaSeleccionada = 'Todas';

	// Ordenamiento
	let orden = { campo: 'descripcion', direccion: 'asc' };

	// Cargar datos al iniciar
	onMount(async () => {
		await cargarDatos();
	});

	// Función para cargar productos y categorías
	async function cargarDatos() {
		try {
			isLoading = true;
			error = null;

			// Cargar productos
			const productosResponse = await fetch('/api/productos');
			if (!productosResponse.ok) throw new Error('Error al cargar productos');
			productos = await productosResponse.json();

			// Cargar categorías
			const categoriasResponse = await fetch('/api/categorias');
			if (!categoriasResponse.ok) throw new Error('Error al cargar categorías');
			categorias = await categoriasResponse.json();
		} catch (error) {
			console.error('Error:', error);
			error = error.message;
		} finally {
			isLoading = false;
		}
	}

	// Productos filtrados y ordenados
	$: productosFiltrados = productos
		.filter(
			(p) =>
				p.descripcion.toLowerCase().includes(filtro.toLowerCase()) &&
				(categoriaSeleccionada === 'Todas' || p.categoria.nombre === categoriaSeleccionada)
		)
		.sort((a, b) => {
			if (orden.campo === 'stock' || orden.campo === 'precio') {
				return orden.direccion === 'asc'
					? a[orden.campo] - b[orden.campo]
					: b[orden.campo] - a[orden.campo];
			} else if (orden.campo === 'categoria') {
				const aValue = a.categoria.nombre.toLowerCase();
				const bValue = b.categoria.nombre.toLowerCase();
				return orden.direccion === 'asc'
					? aValue.localeCompare(bValue)
					: bValue.localeCompare(aValue);
			} else {
				const aValue = a[orden.campo]?.toString().toLowerCase() ?? '';
				const bValue = b[orden.campo]?.toString().toLowerCase() ?? '';
				return orden.direccion === 'asc'
					? aValue.localeCompare(bValue)
					: bValue.localeCompare(aValue);
			}
		});
	// Cambiar ordenamiento
	function ordenarPor(campo: string) {
		if (orden.campo === campo) {
			orden.direccion = orden.direccion === 'asc' ? 'desc' : 'asc';
		} else {
			orden.campo = campo;
			orden.direccion = 'asc';
		}
	}

	// Clase para stock crítico
	function stockClase(stock: number, minimo: number) {
		if (stock === 0) return 'has-text-danger';
		if (stock <= minimo) return 'has-text-warning';
		return 'has-text-success';
	}

	// Obtener nombres de categorías únicas
	$: nombresCategorias = ['Todas', ...new Set(productos.map((p) => p.categoria.nombre))];
</script>

<div class="container">
	<div class="level">
		<div class="level-left">
			<h1 class="title">Inventario de Almacén</h1>
		</div>
		<div class="level-right">
			<button class="button is-primary">
				<span class="icon">
					<i class="fas fa-plus"></i>
				</span>
				<span>Nuevo Producto</span>
			</button>
		</div>
	</div>

	{#if error}
		<div class="notification is-danger">
			<button class="delete" on:click={() => (error = null)}></button>
			{error}
		</div>
	{/if}

	{#if isLoading}
		<div class="has-text-centered">
			<span class="icon is-large">
				<i class="fas fa-spinner fa-pulse fa-3x"></i>
			</span>
			<p>Cargando inventario...</p>
		</div>
	{:else}
		<!-- Filtros -->
		<div class="box">
			<div class="field is-horizontal">
				<div class="field-body">
					<div class="field">
						<p class="control has-icons-left">
							<input
								class="input"
								type="text"
								placeholder="Buscar producto..."
								bind:value={filtro}
							/>
							<span class="icon is-left">
								<i class="fas fa-search"></i>
							</span>
						</p>
					</div>
					<div class="field">
						<div class="select is-fullwidth">
							<select bind:value={categoriaSeleccionada}>
								{#each nombresCategorias as categoria}
									<option value={categoria}>{categoria}</option>
								{/each}
							</select>
						</div>
					</div>
				</div>
			</div>
		</div>

		<!-- Tabla de productos -->
		<div class="box">
			<div class="table-container">
				<table class="table is-fullwidth is-striped is-hoverable">
					<thead>
						<tr>
							<th on:click={() => ordenarPor('codigo')}>
								Código
								{#if orden.campo === 'codigo'}
									<span class="icon">
										<i class={`fas fa-angle-${orden.direccion === 'asc' ? 'up' : 'down'}`}></i>
									</span>
								{/if}
							</th>
							<th on:click={() => ordenarPor('descripcion')}>
								Producto
								{#if orden.campo === 'descripcion'}
									<span class="icon">
										<i class={`fas fa-angle-${orden.direccion === 'asc' ? 'up' : 'down'}`}></i>
									</span>
								{/if}
							</th>
							<th on:click={() => ordenarPor('categoria')}>
								Categoría
								{#if orden.campo === 'categoria'}
									<span class="icon">
										<i class={`fas fa-angle-${orden.direccion === 'asc' ? 'up' : 'down'}`}></i>
									</span>
								{/if}
							</th>
							<th class="has-text-right" on:click={() => ordenarPor('stock')}>
								Stock
								{#if orden.campo === 'stock'}
									<span class="icon">
										<i class={`fas fa-angle-${orden.direccion === 'asc' ? 'up' : 'down'}`}></i>
									</span>
								{/if}
							</th>
							<th class="has-text-right">Mínimo</th>
							<th class="has-text-right" on:click={() => ordenarPor('precio')}>
								Precio
								{#if orden.campo === 'precio'}
									<span class="icon">
										<i class={`fas fa-angle-${orden.direccion === 'asc' ? 'up' : 'down'}`}></i>
									</span>
								{/if}
							</th>
							<th>Acciones</th>
						</tr>
					</thead>
					<tbody>
						{#each productosFiltrados as producto}
							<tr
								class:has-background-danger-light={producto.stock === 0}
								class:has-background-warning-light={producto.stock > 0 &&
									producto.stock <= producto.stock_minimo}
							>
								<td>{producto.codigo}</td>
								<td>
									<p class="has-text-weight-bold">{producto.descripcion}</p>
									{#if producto.modelo}
										<p class="is-size-7 has-text-grey">Modelo: {producto.modelo}</p>
									{/if}
								</td>
								<td>{producto.categoria.nombre}</td>
								<td class="has-text-right">
									<span class={`tag ${stockClase(producto.stock, producto.stock_minimo)}`}>
										{producto.stock}
										{producto.unidad}
									</span>
								</td>
								<td class="has-text-right">{producto.stock_minimo}</td>
								<td class="has-text-right">${producto.precio.toLocaleString()}</td>
								<td>
									<div class="buttons">
										<button class="button is-small is-info is-light">
											<span class="icon">
												<i class="fas fa-edit"></i>
											</span>
										</button>
										<button class="button is-small is-danger is-light">
											<span class="icon">
												<i class="fas fa-trash"></i>
											</span>
										</button>
									</div>
								</td>
							</tr>
						{/each}
					</tbody>
				</table>
			</div>
		</div>

		<!-- Resumen -->
		<div class="level">
			<div class="level-item has-text-centered">
				<div>
					<p class="heading">Total Productos</p>
					<p class="title">{productosFiltrados.length}</p>
				</div>
			</div>
			<div class="level-item has-text-centered">
				<div>
					<p class="heading">Stock Crítico</p>
					<p class="title has-text-warning">
						{productosFiltrados.filter((p) => p.stock > 0 && p.stock <= p.stock_minimo).length}
					</p>
				</div>
			</div>
			<div class="level-item has-text-centered">
				<div>
					<p class="heading">Agotados</p>
					<p class="title has-text-danger">
						{productosFiltrados.filter((p) => p.stock === 0).length}
					</p>
				</div>
			</div>
		</div>
	{/if}
</div>

<style>
	th {
		cursor: pointer;
		user-select: none;
	}
	th:hover {
		background-color: #f5f5f5;
	}
</style>
