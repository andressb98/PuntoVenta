<script lang="ts">
	import { onMount } from 'svelte';

	// Tipos basados en tus modelos
	type Producto = {
		id: number;
		codigo: string;
		descripcion: string;
		precio: number;
		precio_mayoreo: number;
		stock: number;
		unidad: string;
		stock_minimo: number;
	};

	type Cliente = {
		id: number;
		nombre: string;
		telefono: string;
		domicilio: string;
		correo: string;
		usa_credito: boolean;
		credito?: {
			disponible: number;
		};
	};

	type ProductoEnCarrito = Producto & {
		cantidadEnCarrito: number;
		precioVenta: number;
	};

	// Estado
	let productos: Producto[] = [];
	let clientes: Cliente[] = [];
	let carrito: ProductoEnCarrito[] = [];
	let busquedaProducto: string = '';
	let busquedaCliente: string = '';
	let clienteSeleccionado: Cliente | null = null;
	let isLoading = false;
	let error: string | null = null;
	let modalAgregarProducto = false;
	let modalBusquedaProducto = false;
	let modalBusquedaCliente = false;
	let fechaHora = new Date();
	let tipoVenta: 'contado' | 'credito' = 'contado';
	let mostrarPrecioMayoreo = false;

	// Cargar datos al iniciar
	onMount(async () => {
		await cargarDatos();
		setInterval(() => {
			fechaHora = new Date();
		}, 60000); // Actualizar cada minuto
	});

	// Función para cargar productos y clientes
	async function cargarDatos() {
		try {
			isLoading = true;
			error = null;

			// Cargar productos
			const productosResponse = await fetch('/api/productos');
			if (!productosResponse.ok) throw new Error('Error al cargar productos');
			productos = await productosResponse.json();

			// Cargar clientes
			const clientesResponse = await fetch('/api/clientes');
			if (!clientesResponse.ok) throw new Error('Error al cargar clientes');
			clientes = await clientesResponse.json();
		} catch (err) {
			console.error('Error:', err);
			error = err.message;
		} finally {
			isLoading = false;
		}
	}

	// Funciones del carrito
	function agregarAlCarrito(producto: Producto) {
		const existe = carrito.find((p) => p.id === producto.id);
		const precio =
			mostrarPrecioMayoreo && producto.precio_mayoreo ? producto.precio_mayoreo : producto.precio;

		if (existe) {
			if (existe.cantidadEnCarrito < existe.stock) {
				existe.cantidadEnCarrito += 1;
			}
		} else {
			carrito = [
				...carrito,
				{
					...producto,
					cantidadEnCarrito: 1,
					precioVenta: precio
				}
			];
		}
	}

	function eliminarDelCarrito(id: number) {
		carrito = carrito.filter((p) => p.id !== id);
	}

	function ajustarCantidad(id: number, nuevaCantidad: number) {
		carrito = carrito.map((p) => {
			if (p.id === id) {
				return {
					...p,
					cantidadEnCarrito: Math.min(nuevaCantidad, p.stock)
				};
			}
			return p;
		});
	}

	function actualizarPrecio(id: number, nuevoPrecio: number) {
		carrito = carrito.map((p) => {
			if (p.id === id) {
				return {
					...p,
					precioVenta: nuevoPrecio
				};
			}
			return p;
		});
	}

	function calcularSubtotal() {
		return carrito.reduce(
			(total, producto) => total + producto.precioVenta * producto.cantidadEnCarrito,
			0
		);
	}

	function calcularIVA() {
		return calcularSubtotal() * 0.16; // Suponiendo 16% de IVA
	}

	function calcularTotal() {
		return calcularSubtotal() + calcularIVA();
	}

	function limpiarVenta() {
		carrito = [];
		clienteSeleccionado = null;
		tipoVenta = 'contado';
	}

	async function procesarVenta() {
		if (carrito.length === 0) {
			error = 'No hay productos en el carrito';
			return;
		}

		if (tipoVenta === 'credito' && (!clienteSeleccionado || !clienteSeleccionado.usa_credito)) {
			error = 'El cliente seleccionado no tiene crédito habilitado';
			return;
		}

		try {
			isLoading = true;
			const ventaData = {
				fecha: new Date().toISOString(),
				id_cliente: clienteSeleccionado?.id || null,
				tipo_venta: tipoVenta,
				total: calcularTotal(),
				productos: carrito.map((item) => ({
					id_producto: item.id,
					cantidad: item.cantidadEnCarrito,
					precio_unitario: item.precioVenta,
					subtotal: item.precioVenta * item.cantidadEnCarrito
				}))
			};

			const response = await fetch('/api/ventas', {
				method: 'POST',
				headers: {
					'Content-Type': 'application/json'
				},
				body: JSON.stringify(ventaData)
			});

			if (!response.ok) {
				const errorData = await response.json();
				throw new Error(errorData.message || 'Error al procesar la venta');
			}

			// Recargar productos para actualizar stock
			await cargarDatos();
			limpiarVenta();
			error = null;
			alert('Venta procesada exitosamente');
		} catch (err) {
			console.error('Error:', err);
			error = err.message;
		} finally {
			isLoading = false;
		}
	}

	// Filtrado de productos y clientes
	$: productosFiltrados = productos.filter(
		(p) =>
			p.descripcion.toLowerCase().includes(busquedaProducto.toLowerCase()) ||
			p.codigo.toLowerCase().includes(busquedaProducto.toLowerCase())
	);

	$: clientesFiltrados = clientes.filter(
		(c) =>
			c.nombre.toLowerCase().includes(busquedaCliente.toLowerCase()) ||
			c.telefono.includes(busquedaCliente)
	);

	// Formatear fecha y hora
	function formatearFechaHora(fecha: Date) {
		return fecha.toLocaleString('es-MX', {
			weekday: 'long',
			year: 'numeric',
			month: 'long',
			day: 'numeric',
			hour: '2-digit',
			minute: '2-digit'
		});
	}
</script>

<div class="container py-4">
	<h1 class="title is-2">Punto de Venta</h1>

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
			<p>Procesando...</p>
		</div>
	{:else}
		<!-- Encabezado con fecha y selección de cliente -->
		<div class="box">
			<div class="level">
				<div class="level-left">
					<div>
						<p class="heading">Fecha y Hora</p>
						<p class="title is-5">{formatearFechaHora(fechaHora)}</p>
					</div>
				</div>
				<div class="level-right">
					<div class="field">
						<label class="label">Cliente</label>
						<div class="field has-addons">
							<div class="control is-expanded">
								<input
									class="input"
									type="text"
									placeholder="Buscar cliente..."
									bind:value={busquedaCliente}
									on:keydown={(e) => e.key === 'ArrowDown' && (modalBusquedaCliente = true)}
									readonly={!!clienteSeleccionado}
								/>
							</div>
							<div class="control">
								<button class="button" on:click={() => (modalBusquedaCliente = true)}>
									<span class="icon">
										<i class="fas fa-search"></i>
									</span>
								</button>
							</div>
							{#if clienteSeleccionado}
								<div class="control">
									<button class="button is-danger" on:click={() => (clienteSeleccionado = null)}>
										<span class="icon">
											<i class="fas fa-times"></i>
										</span>
									</button>
								</div>
							{/if}
						</div>
					</div>
				</div>
			</div>

			{#if clienteSeleccionado}
				<div class="notification is-light">
					<div class="columns">
						<div class="column">
							<p><strong>Nombre:</strong> {clienteSeleccionado.nombre}</p>
							<p><strong>Teléfono:</strong> {clienteSeleccionado.telefono}</p>
						</div>
						<div class="column">
							<p><strong>Domicilio:</strong> {clienteSeleccionado.domicilio}</p>
							<p><strong>Correo:</strong> {clienteSeleccionado.correo}</p>
						</div>
						<div class="column">
							{#if clienteSeleccionado.usa_credito && clienteSeleccionado.credito}
								<p>
									<strong>Crédito disponible:</strong>
									${clienteSeleccionado.credito.disponible.toFixed(2)}
								</p>
							{/if}
						</div>
					</div>
				</div>
			{/if}
		</div>

		<!-- Sección principal -->
		<div class="columns">
			<!-- Búsqueda de productos -->
			<div class="column is-5">
				<div class="box">
					<h2 class="title is-4">Productos</h2>
					<div class="field has-addons">
						<div class="control is-expanded">
							<input
								class="input is-medium"
								type="text"
								placeholder="Buscar producto por nombre o código..."
								bind:value={busquedaProducto}
								on:keydown={(e) => e.key === 'ArrowDown' && (modalBusquedaProducto = true)}
							/>
						</div>
						<div class="control">
							<button class="button is-medium" on:click={() => (modalBusquedaProducto = true)}>
								<span class="icon">
									<i class="fas fa-search"></i>
								</span>
							</button>
						</div>
						<div class="control">
							<label class="checkbox is-medium" style="padding: 0.5em;">
								<input type="checkbox" bind:checked={mostrarPrecioMayoreo} />
								Mayoreo
							</label>
						</div>
					</div>

					<div class="table-container" style="max-height: 50vh; overflow-y: auto;">
						<table class="table is-fullwidth is-hoverable">
							<thead>
								<tr>
									<th>Código</th>
									<th>Producto</th>
									<th>Precio</th>
									<th>Stock</th>
									<th>Acciones</th>
								</tr>
							</thead>
							<tbody>
								{#each productosFiltrados.slice(0, 5) as producto}
									<tr>
										<td>{producto.codigo}</td>
										<td>{producto.descripcion}</td>
										<td
											>${(mostrarPrecioMayoreo && producto.precio_mayoreo
												? producto.precio_mayoreo
												: producto.precio
											).toFixed(2)}</td
										>
										<td>{producto.stock} {producto.unidad}</td>
										<td>
											<button
												class="button is-small is-success"
												on:click={() => agregarAlCarrito(producto)}
												disabled={producto.stock <= 0}
											>
												<span class="icon">
													<i class="fas fa-cart-plus"></i>
												</span>
											</button>
										</td>
									</tr>
								{/each}
							</tbody>
						</table>
					</div>
				</div>
			</div>

			<!-- Carrito de compras -->
			<div class="column is-7">
				<div class="box">
					<div class="level">
						<div class="level-left">
							<h2 class="title is-4">Detalle de Venta</h2>
						</div>
						<div class="level-right">
							<div class="field">
								<div class="control">
									<label class="radio">
										<input type="radio" name="tipoVenta" value="contado" bind:group={tipoVenta} />
										Contado
									</label>
									<label class="radio">
										<input
											type="radio"
											name="tipoVenta"
											value="credito"
											bind:group={tipoVenta}
											disabled={!clienteSeleccionado?.usa_credito}
										/>
										Crédito
									</label>
								</div>
							</div>
						</div>
					</div>

					<div class="table-container" style="max-height: 50vh; overflow-y: auto;">
						<table class="table is-fullwidth is-hoverable">
							<thead>
								<tr>
									<th>Producto</th>
									<th>Precio</th>
									<th>Cantidad</th>
									<th>Subtotal</th>
									<th>Acciones</th>
								</tr>
							</thead>
							<tbody>
								{#each carrito as item (item.id)}
									<tr>
										<td>{item.descripcion}</td>
										<td>
											<input
												class="input is-small"
												type="number"
												min="0.01"
												step="0.01"
												bind:value={item.precioVenta}
												on:change={(e) => actualizarPrecio(item.id, parseFloat(e.target.value))}
												style="width: 80px;"
											/>
										</td>
										<td>
											<input
												class="input is-small"
												type="number"
												min="1"
												max={item.stock}
												bind:value={item.cantidadEnCarrito}
												on:change={(e) => ajustarCantidad(item.id, parseInt(e.target.value))}
												style="width: 60px;"
											/>
										</td>
										<td>${(item.precioVenta * item.cantidadEnCarrito).toFixed(2)}</td>
										<td>
											<button
												class="button is-small is-danger"
												on:click={() => eliminarDelCarrito(item.id)}
											>
												<span class="icon">
													<i class="fas fa-trash"></i>
												</span>
											</button>
										</td>
									</tr>
								{/each}
							</tbody>
						</table>
					</div>

					{#if carrito.length === 0}
						<p class="has-text-centered py-4">No hay productos en la venta</p>
					{/if}

					<hr />

					<!-- Resumen de la venta -->
					<div class="content">
						<div class="is-flex is-justify-content-space-between">
							<p><strong>Subtotal:</strong></p>
							<p>${calcularSubtotal().toFixed(2)}</p>
						</div>
						<div class="is-flex is-justify-content-space-between">
							<p><strong>IVA (16%):</strong></p>
							<p>${calcularIVA().toFixed(2)}</p>
						</div>
						<div class="is-flex is-justify-content-space-between">
							<p class="has-text-weight-bold">Total:</p>
							<p class="has-text-weight-bold">${calcularTotal().toFixed(2)}</p>
						</div>
					</div>

					<!-- Botones de acción -->
					<div class="buttons is-right mt-4">
						<button
							class="button is-danger"
							on:click={limpiarVenta}
							disabled={carrito.length === 0}
						>
							<span class="icon">
								<i class="fas fa-trash"></i>
							</span>
							<span>Cancelar Venta</span>
						</button>
						<button
							class="button is-success"
							on:click={procesarVenta}
							disabled={carrito.length === 0 ||
								(tipoVenta === 'credito' &&
									(!clienteSeleccionado ||
										calcularTotal() > (clienteSeleccionado?.credito?.disponible || 0)))}
						>
							<span class="icon">
								<i class="fas fa-cash-register"></i>
							</span>
							<span>Procesar Venta</span>
						</button>
					</div>
				</div>
			</div>
		</div>
	{/if}

	<!-- Modal de búsqueda de productos -->
	<div class="modal" class:is-active={modalBusquedaProducto}>
		<div class="modal-background" on:click={() => (modalBusquedaProducto = false)}></div>
		<div class="modal-card" style="width: 80%;">
			<header class="modal-card-head">
				<p class="modal-card-title">Buscar Producto</p>
				<button class="delete" aria-label="close" on:click={() => (modalBusquedaProducto = false)}
				></button>
			</header>
			<section class="modal-card-body">
				<div class="field">
					<div class="control has-icons-left">
						<input
							class="input is-medium"
							type="text"
							placeholder="Buscar producto por nombre o código..."
							bind:value={busquedaProducto}
						/>
						<span class="icon is-left">
							<i class="fas fa-search"></i>
						</span>
					</div>
				</div>

				<div class="table-container" style="max-height: 60vh; overflow-y: auto;">
					<table class="table is-fullwidth is-hoverable">
						<thead>
							<tr>
								<th>Código</th>
								<th>Producto</th>
								<th>Precio</th>
								<th>Precio Mayoreo</th>
								<th>Stock</th>
								<th>Acciones</th>
							</tr>
						</thead>
						<tbody>
							{#each productosFiltrados as producto}
								<tr>
									<td>{producto.codigo}</td>
									<td>{producto.descripcion}</td>
									<td>${producto.precio.toFixed(2)}</td>
									<td>${producto.precio_mayoreo?.toFixed(2) || 'N/A'}</td>
									<td>{producto.stock} {producto.unidad}</td>
									<td>
										<button
											class="button is-small is-success"
											on:click={() => {
												agregarAlCarrito(producto);
												modalBusquedaProducto = false;
											}}
											disabled={producto.stock <= 0}
										>
											<span class="icon">
												<i class="fas fa-cart-plus"></i>
											</span>
											<span>Agregar</span>
										</button>
									</td>
								</tr>
							{/each}
						</tbody>
					</table>
				</div>
			</section>
			<footer class="modal-card-foot">
				<button class="button" on:click={() => (modalBusquedaProducto = false)}>Cerrar</button>
			</footer>
		</div>
	</div>

	<!-- Modal de búsqueda de clientes -->
	<div class="modal" class:is-active={modalBusquedaCliente}>
		<div class="modal-background" on:click={() => (modalBusquedaCliente = false)}></div>
		<div class="modal-card" style="width: 80%;">
			<header class="modal-card-head">
				<p class="modal-card-title">Buscar Cliente</p>
				<button class="delete" aria-label="close" on:click={() => (modalBusquedaCliente = false)}
				></button>
			</header>
			<section class="modal-card-body">
				<div class="field">
					<div class="control has-icons-left">
						<input
							class="input is-medium"
							type="text"
							placeholder="Buscar cliente por nombre o teléfono..."
							bind:value={busquedaCliente}
						/>
						<span class="icon is-left">
							<i class="fas fa-search"></i>
						</span>
					</div>
				</div>

				<div class="table-container" style="max-height: 60vh; overflow-y: auto;">
					<table class="table is-fullwidth is-hoverable">
						<thead>
							<tr>
								<th>Nombre</th>
								<th>Teléfono</th>
								<th>Domicilio</th>
								<th>Crédito</th>
								<th>Acciones</th>
							</tr>
						</thead>
						<tbody>
							{#each clientesFiltrados as cliente}
								<tr>
									<td>{cliente.nombre}</td>
									<td>{cliente.telefono}</td>
									<td>{cliente.domicilio}</td>
									<td>
										{#if cliente.usa_credito && cliente.credito}
											${cliente.credito.disponible.toFixed(2)}
										{:else}
											Sin crédito
										{/if}
									</td>
									<td>
										<button
											class="button is-small is-primary"
											on:click={() => {
												clienteSeleccionado = cliente;
												modalBusquedaCliente = false;
											}}
										>
											<span class="icon">
												<i class="fas fa-check"></i>
											</span>
											<span>Seleccionar</span>
										</button>
									</td>
								</tr>
							{/each}
						</tbody>
					</table>
				</div>
			</section>
			<footer class="modal-card-foot">
				<button class="button" on:click={() => (modalBusquedaCliente = false)}>Cerrar</button>
			</footer>
		</div>
	</div>
</div>

<style>
	.table-container {
		overflow-y: auto;
	}
	th {
		cursor: default;
	}
	.modal-card {
		max-width: 90%;
	}
	.notification {
		margin-bottom: 1rem;
	}
</style>
