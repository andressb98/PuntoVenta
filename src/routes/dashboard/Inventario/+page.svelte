<script lang="ts">
    // Datos de ejemplo - luego reemplazar con carga desde API
    let productos = [
      { id: 1, nombre: 'Laptop HP 15', categoria: 'Electrónicos', stock: 15, precio: 12000, minimo: 5 },
      { id: 2, nombre: 'Mouse Inalámbrico', categoria: 'Accesorios', stock: 42, precio: 350, minimo: 10 },
      { id: 3, nombre: 'Teclado Mecánico', categoria: 'Accesorios', stock: 8, precio: 899, minimo: 5 },
      { id: 4, nombre: 'Monitor 24"', categoria: 'Electrónicos', stock: 6, precio: 4500, minimo: 3 },
      { id: 5, nombre: 'Impresora Multifuncional', categoria: 'Oficina', stock: 3, precio: 2500, minimo: 2 },
    ];
  
    // Filtros
    let filtro = '';
    let categoriaSeleccionada = 'Todas';
    let categorias = ['Todas', ...new Set(productos.map(p => p.categoria))];
  
    // Ordenamiento
    let orden = { campo: 'nombre', direccion: 'asc' };
  
    // Productos filtrados y ordenados
    $: productosFiltrados = productos
      .filter(p => 
        p.nombre.toLowerCase().includes(filtro.toLowerCase()) &&
        (categoriaSeleccionada === 'Todas' || p.categoria === categoriaSeleccionada)
      )
      .sort((a, b) => {
        if (orden.campo === 'stock') {
          return orden.direccion === 'asc' ? a.stock - b.stock : b.stock - a.stock;
        } else {
          const aValue = a[orden.campo].toString().toLowerCase();
          const bValue = b[orden.campo].toString().toLowerCase();
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
  
    <!-- Filtros -->
    <div class="box">
      <div class="field is-horizontal">
        <div class="field-body">
          <div class="field">
            <p class="control has-icons-left">
              <input class="input" type="text" placeholder="Buscar producto..." bind:value={filtro}>
              <span class="icon is-left">
                <i class="fas fa-search"></i>
              </span>
            </p>
          </div>
          <div class="field">
            <div class="select is-fullwidth">
              <select bind:value={categoriaSeleccionada}>
                {#each categorias as categoria}
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
              <th on:click={() => ordenarPor('nombre')}>
                Producto
                {#if orden.campo === 'nombre'}
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
              <tr class:has-background-danger-light={producto.stock === 0}
                  class:has-background-warning-light={producto.stock > 0 && producto.stock <= producto.minimo}>
                <td>{producto.nombre}</td>
                <td>{producto.categoria}</td>
                <td class="has-text-right">
                  <span class={`tag ${stockClase(producto.stock, producto.minimo)}`}>
                    {producto.stock}
                  </span>
                </td>
                <td class="has-text-right">{producto.minimo}</td>
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
            {productosFiltrados.filter(p => p.stock > 0 && p.stock <= p.minimo).length}
          </p>
        </div>
      </div>
      <div class="level-item has-text-centered">
        <div>
          <p class="heading">Agotados</p>
          <p class="title has-text-danger">
            {productosFiltrados.filter(p => p.stock === 0).length}
          </p>
        </div>
      </div>
    </div>
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