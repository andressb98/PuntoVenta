<script lang="ts">
	import { onMount } from 'svelte';

	// Tipos
	type Producto = {
		id: number;
		codigo: string;
		descripcion: string;
		precio: number;
		costo: number;
		iva: number;
		id_categoria: number;
		id_almacen: number;
		stock: number;
		nombre: string; // Agregado para mostrar el nombre de la categoría
		stock_minimo: number | null;
	};

	type Categoria = {
		id: number;
		nombre: string;
	};

	type Almacen = {
		id: number;
		nombre: string;
	};

	// Variables de estado
	let almacenes: Almacen[] = [];
	let productos: Producto[] = [];
	let busqueda: string = '';
	let modalAgregarProducto = false;
	let modalMovimiento = false;
	let tipoMovimiento: 'entrada' | 'salida' = 'entrada';
	let productoSeleccionado: Producto | null = null;
	let cantidadMovimiento: number = 1;
	let categorias: Categoria[] = [];

	// Nuevo producto
	let nuevoProducto = {
		codigo: '',
		descripcion: '',
		precio: 0,
		costo: 0,
		iva: 0.16, // Valor por defecto
		id_categoria: 0,
		id_almacen: 0,
		stock: 0,
		nombre: '',
		incluirDetallesOpcionales: false,
		precio_mayoreo: null as number | null,
		modelo: null as string | null,
		stock_minimo: null as number | null,
		unidad: ''
	};

	let errorMensaje: string | null = null;

	// Cargar productos
	async function cargarProductos() {
		try {
			const response = await fetch('/api/productos');
			if (response.ok) {
				productos = await response.json();
			} else {
				console.error('Error al cargar productos');
			}
		} catch (error) {
			console.error('Error de red:', error);
		}
	}

	// Cargar categorías
	async function cargarCategorias() {
		try {
			const response = await fetch('/api/categorias');
			if (response.ok) {
				categorias = await response.json();
				// Si hay categorías, inicializa el id_categoria del nuevo producto con la primera
				if (categorias.length > 0) {
					nuevoProducto.id_categoria = categorias[0].id;
				}
			} else {
				console.error('Error al cargar categorías');
			}
		} catch (error) {
			console.error('Error de red:', error);
		}
	}

	// Cargar Almacenes
	async function cargarAlmacenes() {
		try {
			const response = await fetch('/api/almacenes');
			if (response.ok) {
				almacenes = await response.json();
			} else {
				console.error('Error al cargar categorías');
			}
		} catch (error) {
			console.error('Error de red:', error);
		}
	}

	onMount(async () => {
		await cargarCategorias();
		await cargarProductos();
		cargarAlmacenes();
	});

	// Función agregarEntrada
	async function agregarEntrada(almacenId: number, importe: number, productoId: number) {
		const observaciones = 'Nuevo Producto';
		const idUsuario = 1; // Por defecto

		try {
			const nuevaEntrada = await fetch('/api/entradas', {
				// Llamada a la API para crear la entrada
				method: 'POST',
				headers: {
					'Content-Type': 'application/json'
				},
				body: JSON.stringify({
					id_almacen: almacenId,
					importe: importe,
					observaciones: observaciones,
					id_usuario: idUsuario
				})
			});

			if (!nuevaEntrada.ok) {
				const errorData = await nuevaEntrada.json();
				throw new Error(errorData.error || 'Error al agregar entrada');
			}

			const entradaCreada = await nuevaEntrada.json();
			const entradaId = entradaCreada.id;

			return { entradaId, productoId }; // Devolver ambos IDs
		} catch (error: any) {
			console.error('Error al agregar entrada:', error);
			throw error; // Re-lanzar el error para que lo maneje la función que llama a agregarEntrada
		}
	}

	async function agregarProducto() {
		errorMensaje = null;

		// Validación de campos requeridos
		if (
			!nuevoProducto.codigo ||
			!nuevoProducto.descripcion ||
			!nuevoProducto.precio ||
			!nuevoProducto.costo ||
			!nuevoProducto.id_categoria ||
			!nuevoProducto.id_almacen ||
			!nuevoProducto.stock ||
			!nuevoProducto.unidad
		) {
			errorMensaje = 'Todos los campos requeridos deben ser completados.';
			return;
		}

		const productoData: any = {
			codigo: nuevoProducto.codigo,
			descripcion: nuevoProducto.descripcion,
			precio: nuevoProducto.precio,
			costo: nuevoProducto.costo,
			iva: nuevoProducto.iva,
			id_categoria: nuevoProducto.id_categoria,
			id_almacen: nuevoProducto.id_almacen,
			stock: nuevoProducto.stock,
			unidad: nuevoProducto.unidad
		};

		if (nuevoProducto.incluirDetallesOpcionales) {
			productoData.precio_mayoreo = nuevoProducto.precio_mayoreo;
			productoData.modelo = nuevoProducto.modelo;
			productoData.stock_minimo = nuevoProducto.stock_minimo;
		}

		try {
			const response = await fetch('/api/productos', {
				method: 'POST',
				headers: {
					'Content-Type': 'application/json'
				},
				body: JSON.stringify(productoData)
			});

			if (!response.ok) {
				const errorData = await response.json();
				errorMensaje = errorData.error || 'Error al agregar producto';
				return;
			}

			const nuevoProductoCreado = await response.json(); // Obtener la respuesta JSON
			const nuevoProductoId = nuevoProductoCreado.id; // Extraer el ID del producto
			const importeEntrada = nuevoProducto.stock * nuevoProducto.precio;
			const { entradaId } = await agregarEntrada(
				nuevoProducto.id_almacen,
				importeEntrada,
				nuevoProductoId
			); // Pasar el id del almacen

			await agregarMovimiento(nuevoProductoId, entradaId);
		} catch (error: any) {
			console.error('Error de red:', error);
			errorMensaje = error.message || 'Error de conexión con el servidor';
		}
	}

	// Agregar movimiento
	async function agregarMovimiento(productoId: number, entradaId: number) {
		// Añadir el parámetro productoId
		errorMensaje = null;

		const movimientoData: any = {
			id_producto: productoId, // Usar el ID del producto creado
			id_almacen: nuevoProducto.id_almacen,
			costo: nuevoProducto.costo,
			stock: nuevoProducto.stock,
			id_entrada: entradaId
		};

		try {
			const response = await fetch('/api/movimientos', {
				// Asegúrate de que la ruta de la API es correcta
				method: 'POST',
				headers: {
					'Content-Type': 'application/json'
				},
				body: JSON.stringify(movimientoData)
			});

			if (!response.ok) {
				const errorData = await response.json();
				errorMensaje = errorData.error || 'Error al agregar movimiento';
				return;
			}

			// Si es necesario, procesar la respuesta del movimiento
			const movimientoResponseData = await response.json();
			console.log('Respuesta de agregarMovimiento:', movimientoResponseData);

			await cargarProductos();
			resetearFormulario();
			modalAgregarProducto = false;
		} catch (error) {
			console.error('Error de red:', error);
			errorMensaje = 'Error de conexión con el servidor';
		}
	}

	// Eliminar producto
	async function eliminarProducto(id: number) {
		try {
			const response = await fetch(`/api/productos/${id}`, {
				method: 'DELETE'
			});

			if (response.ok) {
				await cargarProductos();
			} else {
				console.error('Error al eliminar producto');
			}
		} catch (error) {
			console.error('Error de red:', error);
		}
	}

	// Preparar movimiento
	function prepararMovimiento(producto: Producto, tipo: 'entrada' | 'salida') {
		productoSeleccionado = { ...producto }; // Copia para no modificar el original directamente
		tipoMovimiento = tipo;
		cantidadMovimiento = 1; // Resetear la cantidad
		modalMovimiento = true;
	}

	// Procesar movimiento
	async function procesarMovimiento() {
		if (!productoSeleccionado) return;

		try {
			const response = await fetch(`/api/productos/${productoSeleccionado.id}/movimiento`, {
				method: 'POST',
				headers: {
					'Content-Type': 'application/json'
				},
				body: JSON.stringify({
					cantidad: cantidadMovimiento,
					tipo: tipoMovimiento
				})
			});

			if (response.ok) {
				await cargarProductos(); // Recargar la lista de productos para reflejar el cambio
				modalMovimiento = false;
				productoSeleccionado = null; // Limpiar el producto seleccionado
			} else {
				const errorData = await response.json();
				errorMensaje = errorData.error || 'Error al procesar movimiento';
				console.error('Error al procesar movimiento:', errorMensaje);
			}
		} catch (error) {
			console.error('Error de red:', error);
			errorMensaje = 'Error de conexión con el servidor';
		}
	}

	// Resetear formulario
	function resetearFormulario() {
		nuevoProducto = {
			codigo: '',
			descripcion: '',
			precio: 0,
			costo: 0,
			iva: 0.16,
			id_categoria: categorias.length > 0 ? categorias[0].id : 0,
			id_almacen: almacenes.length > 0 ? almacenes[0].id : 0,
			stock: 0,
			nombre: '',
			incluirDetallesOpcionales: false,
			precio_mayoreo: null,
			modelo: null,
			stock_minimo: null,
			unidad: ''
		};
	}

	// Filtrado
	$: productosFiltrados = productos.filter(
		(p) =>
			p.codigo.toLowerCase().includes(busqueda.toLowerCase()) ||
			p.descripcion.toLowerCase().includes(busqueda.toLowerCase())
	);
</script>

<div class="container py-4">
	<h1 class="title is-2">Gestión de Productos</h1>

	<div class="level">
		<div class="level-left">
			<div class="level-item">
				<div class="field has-addons">
					<div class="control">
						<input
							class="input"
							type="text"
							placeholder="Buscar productos..."
							bind:value={busqueda}
						/>
					</div>
					<div class="control">
						<button class="button is-info">
							<span class="icon">
								<i class="fas fa-search"></i>
							</span>
						</button>
					</div>
				</div>
			</div>
		</div>
		<div class="level-right">
			<div class="level-item">
				<button class="button is-primary" on:click={() => (modalAgregarProducto = true)}>
					<span class="icon">
						<i class="fas fa-plus"></i>
					</span>
					<span>Nuevo Producto</span>
				</button>
			</div>
		</div>
	</div>

	<div class="box">
		<div class="table-container">
			<table class="table is-fullwidth is-hoverable is-striped">
				<thead>
					<tr>
						<th>Código</th>
						<th>Nombre</th>
						<th>Descripción</th>
						<th>Precio</th>
						<th>Costo</th>
						<th>Stock</th>
						<th>Categoría</th>
						<th>Acciones</th>
					</tr>
				</thead>
				<tbody>
					{#each productosFiltrados as producto (producto.id)}
						<tr>
							<td>{producto.codigo}</td>
							<td>{producto.descripcion}</td>
							<td>${Number(producto.precio).toFixed(2)}</td>
							<td>${Number(producto.costo).toFixed(2)}</td>
							<td>
								<span
									class="tag is-rounded {producto.stock <= producto.stock_minimo
										? 'is-danger'
										: 'is-success'}"
								>
									{producto.stock}
								</span>
								{#if producto.stock <= producto.stock_minimo}
									<span class="icon has-text-warning ml-1" title="Stock mínimo alcanzado">
										<i class="fas fa-exclamation-triangle"></i>
									</span>
								{/if}
							</td>
							<td>{producto.nombre}</td>
							<td>
								<div class="buttons are-small">
									<button class="button is-info is-light" on:click={() => {}}>
										<span class="icon">
											<i class="fas fa-edit"></i>
										</span>
									</button>
									<button
										class="button is-danger is-light"
										on:click={() => eliminarProducto(producto.id)}
									>
										<span class="icon">
											<i class="fas fa-trash"></i>
										</span>
									</button>
									<button
										class="button is-success is-light"
										on:click={() => prepararMovimiento(producto, 'entrada')}
									>
										<span class="icon">
											<i class="fas fa-arrow-down"></i>
										</span>
										<span>Entrada</span>
									</button>
									<button
										class="button is-warning is-light"
										on:click={() => prepararMovimiento(producto, 'salida')}
									>
										<span class="icon">
											<i class="fas fa-arrow-up"></i>
										</span>
										<span>Salida</span>
									</button>
								</div>
							</td>
						</tr>
					{/each}
				</tbody>
			</table>
		</div>
	</div>

	<div class="modal" class:is-active={modalAgregarProducto}>
		<div class="modal-background" on:click={() => (modalAgregarProducto = false)}></div>
		<div class="modal-card">
			<header class="modal-card-head">
				<p class="modal-card-title">Agregar Nuevo Producto</p>
				<button class="delete" aria-label="close" on:click={() => (modalAgregarProducto = false)}
				></button>
			</header>
			<section class="modal-card-body">
				<div class="field">
					<label class="label">Código</label>
					<div class="control">
						<input
							class="input"
							type="text"
							placeholder="Código único"
							bind:value={nuevoProducto.codigo}
						/>
					</div>
				</div>
				<div class="field">
					<label class="label">Descripción</label>
					<div class="control">
						<textarea
							class="textarea"
							placeholder="Descripción detallada"
							bind:value={nuevoProducto.descripcion}
						></textarea>
					</div>
				</div>
				<div class="columns">
					<div class="column">
						<div class="field">
							<label class="label">Precio de Venta</label>
							<div class="control">
								<input
									class="input"
									type="number"
									min="0"
									step="0.01"
									bind:value={nuevoProducto.precio}
								/>
							</div>
						</div>
					</div>
					<div class="column">
						<div class="field">
							<label class="label">Costo</label>
							<div class="control">
								<input
									class="input"
									type="number"
									min="0"
									step="0.01"
									bind:value={nuevoProducto.costo}
								/>
							</div>
						</div>
					</div>
				</div>
				<div class="field">
					<label class="label">IVA</label>
					<div class="control">
						<input class="input" type="number" min="0" step="0.01" bind:value={nuevoProducto.iva} />
					</div>
				</div>
				<div class="field">
					<label class="label">Categoría</label>
					<div class="control">
						<select class="select is-fullwidth" bind:value={nuevoProducto.id_categoria}>
							{#each categorias as categoria}
								<option value={categoria.id}>{categoria.nombre}</option>
							{/each}
						</select>
					</div>
				</div>
				<div class="field">
					<label class="label">Almacen</label>
					<div class="control">
						<select class="select is-fullwidth" bind:value={nuevoProducto.id_almacen}>
							{#each almacenes as almacenes}
								<option value={almacenes.id}>{almacenes.nombre}</option>
							{/each}
						</select>
					</div>
				</div>
				<div class="field">
					<label class="label">Stock Inicial</label>
					<div class="control">
						<input class="input" type="number" min="0" bind:value={nuevoProducto.stock} />
					</div>
				</div>
				<div class="field">
					<label class="label">Unidad</label>
					<div class="control">
						<input
							class="input"
							type="text"
							placeholder="Ej: kg, pza, lt"
							bind:value={nuevoProducto.unidad}
						/>
					</div>
				</div>
				<div class="field">
					<label class="checkbox">
						<input type="checkbox" bind:checked={nuevoProducto.incluirDetallesOpcionales} />
						Agregar detalles opcionales
					</label>
				</div>

				{#if nuevoProducto.incluirDetallesOpcionales}
					<div class="columns">
						<div class="column">
							<div class="field">
								<label class="label">Precio Mayoreo</label>
								<div class="control">
									<input
										class="input"
										type="number"
										min="0"
										step="0.01"
										bind:value={nuevoProducto.precio_mayoreo}
									/>
								</div>
							</div>
						</div>
						<div class="column">
							<div class="field">
								<label class="label">Modelo</label>
								<div class="control">
									<input
										class="input"
										type="text"
										placeholder="Modelo del producto"
										bind:value={nuevoProducto.modelo}
									/>
								</div>
							</div>
						</div>
						<div class="column">
							<div class="field">
								<label class="label">Stock Mínimo</label>
								<div class="control">
									<input
										class="input"
										type="number"
										min="0"
										bind:value={nuevoProducto.stock_minimo}
									/>
								</div>
							</div>
						</div>
					</div>
				{/if}
			</section>
			{#if errorMensaje}
				<div class="notification is-danger is-light">
					<button class="delete" on:click={() => (errorMensaje = null)}></button>
					{errorMensaje}
				</div>
			{/if}
			<footer class="modal-card-foot">
				<button class="button is-success" on:click={agregarProducto}>Guardar Producto</button>
				<button class="button" on:click={() => (modalAgregarProducto = false)}>Cancelar</button>
			</footer>
		</div>
	</div>

	<div class="modal" class:is-active={modalMovimiento}>
		<div class="modal-background" on:click={() => (modalMovimiento = false)}></div>
		<div class="modal-card">
			<header class="modal-card-head">
				<p class="modal-card-title">
					{tipoMovimiento === 'entrada' ? 'Entrada de Inventario' : 'Salida de Inventario'}
				</p>
				<button class="delete" aria-label="close" on:click={() => (modalMovimiento = false)}
				></button>
			</header>
			<section class="modal-card-body">
				{#if productoSeleccionado}
					<div class="content">
						<p><strong>Producto:</strong> {productoSeleccionado.descripcion}</p>
						<p><strong>Código:</strong> {productoSeleccionado.codigo}</p>
						<p><strong>Stock actual:</strong> {productoSeleccionado.stock}</p>

						<div class="field">
							<label class="label"
								>Cantidad a {tipoMovimiento === 'entrada' ? 'ingresar' : 'retirar'}</label
							>
							<div class="control">
								<input class="input" type="number" min="1" bind:value={cantidadMovimiento} />
							</div>
						</div>

						{#if tipoMovimiento === 'salida'}
							<div class="notification is-warning is-light">
								<p>Verifica que tengas suficiente stock disponible antes de registrar la salida.</p>
								<p>
									Stock después de la operación: {productoSeleccionado.stock - cantidadMovimiento}
								</p>
							</div>
						{/if}
						{#if errorMensaje}
							<div class="notification is-danger is-light">
								<button class="delete" on:click={() => (errorMensaje = null)}></button>
								{errorMensaje}
							</div>
						{/if}
					</div>
				{/if}
			</section>
			<footer class="modal-card-foot">
				<button class="button is-primary" on:click={procesarMovimiento}>
					Confirmar {tipoMovimiento === 'entrada' ? 'Entrada' : 'Salida'}
				</button>
				<button class="button" on:click={() => (modalMovimiento = false)}>Cancelar</button>
			</footer>
		</div>
	</div>
</div>

<style>
	.table-container {
		max-height: 70vh;
		overflow-y: auto;
	}

	.buttons .button {
		margin-bottom: 0.25rem;
	}
</style>
