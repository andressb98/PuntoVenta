<script lang="ts">
	import { page } from '$app/stores';
  import { goto } from '$app/navigation';
	let activeItem = 'Inicio';

	const menuItems = [
		{ name: 'dashboard', display: 'Inicio', icon: 'fas fa-home', route: '/dashboard' },
		{
			name: 'PuntoVenta',
			display: 'Punto de Venta',
			icon: 'fas fa-cash-register',
			route: '/dashboard/PuntoVenta'
		},
		{
			name: 'Productos',
			display: 'Productos',
			icon: 'fas fa-boxes',
			route: '/dashboard/Productos'
		},
    {
			name: 'Inventario',
			display: 'Inventario',
			icon: 'fas fa-boxes',
			route: '/dashboard/Inventario'
		},
		{
			name: 'Proveedores',
			display: 'Proveedores',
			icon: 'fas fa-truck',
			route: '/dashboard/Proveedores'
		},
		{ name: 'Almacen', display: 'Almacén', icon: 'fas fa-warehouse', route: '/dashboard/Almacen' },
		{ name: 'Clientes', display: 'Clientes', icon: 'fas fa-users', route: '/dashboard/Clientes' },
		{ name: 'Ventas', display: 'Ventas', icon: 'fas fa-chart-line', route: '/dashboard/Ventas' },
		{
			name: 'Reportes',
			display: 'Reportes',
			icon: 'fas fa-file-alt',
			route: '/dashboard/Reportes'
		},
		{
			name: 'Configuracion',
			display: 'Configuración',
			icon: 'fas fa-cog',
			route: '/dashboard/Configuracion'
		}
	];

	function navigateTo(route: string) {
		goto(route);
	}
</script>

<aside class="sidebar">
	<div class="sidebar-menu">
		<div class="sidebar-brand">
			<span class="icon has-text-primary">
				<i class="fas fa-store-alt"></i>
			</span>
			<span>Mi Tienda</span>
		</div>

		<ul class="menu-list">
			{#each menuItems as item}
				<li>
					<a class:active={activeItem === item.name} on:click={() => navigateTo(item.route)}>
						<span class="icon">
							<i class={item.icon}></i>
						</span>
						<span>{item.display}</span>
					</a>
				</li>
			{/each}
		</ul>
	</div>
</aside>

<style lang="postcss">
	.sidebar {
		width: 250px;
		background-color: #fff;
		box-shadow: 1px 0 3px rgba(0, 0, 0, 0.1);
		transition: width 0.3s ease;
		height: 100vh;
		position: sticky;
		top: 0;
		z-index: 30;
	}

	.sidebar-brand {
		display: flex;
		align-items: center;
		padding: 1.5rem 1rem;
		font-size: 1.2rem;
		font-weight: bold;
		border-bottom: 1px solid #eee;
		margin-bottom: 1rem;
	}

	.sidebar-brand .icon {
		margin-right: 0.75rem;
		font-size: 1.5rem;
	}

	.menu-list {
		padding: 0 1rem;
	}

	.menu-list a {
		display: flex;
		align-items: center;
		padding: 0.75rem 1rem;
		border-radius: 4px;
		color: #4a4a4a;
		margin-bottom: 0.5rem;
		transition: all 0.3s ease;
	}

	.menu-list a:hover {
		background-color: #f5f5f5;
		color: #3273dc;
	}

	.menu-list a.active {
		background-color: #3273dc;
		color: white;
	}

	.menu-list a .icon {
		margin-right: 0.75rem;
		width: 20px;
		justify-content: center;
	}

	@media screen and (max-width: 1023px) {
		.sidebar {
			width: 70px;
			overflow: hidden;
		}

		.sidebar-brand span:last-child {
			display: none;
		}

		.menu-list a span:last-child {
			display: none;
		}

		.menu-list a .icon {
			margin-right: 0;
			font-size: 1.2rem;
		}
	}
</style>
