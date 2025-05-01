<script lang="ts">
    // Tipos
    type Producto = {
      id: number;
      nombre: string;
      precio: number;
      cantidad: number;
    };
  
    type ProductoEnCarrito = Producto & {
      cantidadEnCarrito: number;
    };
  
    // Estado
    let productos: Producto[] = [
      { id: 1, nombre: "Producto 1", precio: 100, cantidad: 10 },
      { id: 2, nombre: "Producto 2", precio: 200, cantidad: 5 },
      { id: 3, nombre: "Producto 3", precio: 150, cantidad: 8 },
    ];
  
    let carrito: ProductoEnCarrito[] = [];
    let busqueda: string = "";
    let nuevoProducto: Omit<Producto, "id"> = {
      nombre: "",
      precio: 0,
      cantidad: 0,
    };

    let modalAgregarProducto: boolean = false; // <-- Esta es la variable que faltaba
  
    // Funciones
    function agregarAlCarrito(producto: Producto) {
      const existe = carrito.find((p) => p.id === producto.id);
  
      if (existe) {
        if (existe.cantidadEnCarrito < existe.cantidad) {
          existe.cantidadEnCarrito += 1;
        }
      } else {
        carrito = [
          ...carrito,
          { ...producto, cantidadEnCarrito: 1 },
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
            cantidadEnCarrito: Math.min(nuevaCantidad, p.cantidad),
          };
        }
        return p;
      });
    }
  
    function calcularTotal() {
      return carrito.reduce(
        (total, producto) => total + producto.precio * producto.cantidadEnCarrito,
        0
      );
    }
  
    function agregarNuevoProducto() {
      if (nuevoProducto.nombre && nuevoProducto.precio > 0) {
        const nuevoId = Math.max(...productos.map((p) => p.id), 0) + 1;
        productos = [
          ...productos,
          {
            id: nuevoId,
            ...nuevoProducto,
          },
        ];
        nuevoProducto = { nombre: "", precio: 0, cantidad: 0 };
      }
    }
  
    // Filtrado de productos
    $: productosFiltrados = productos.filter((p) =>
      p.nombre.toLowerCase().includes(busqueda.toLowerCase())
    );
  </script>
  
  <div class="container py-4">
    <h1 class="title is-2">Punto de Venta</h1>
  
    <!-- Sección de búsqueda y agregar producto -->
    <div class="columns mb-5">
      <div class="column is-8">
        <div class="field">
          <div class="control has-icons-left">
            <input
              class="input is-medium"
              type="text"
              placeholder="Buscar producto..."
              bind:value={busqueda}
            />
            <span class="icon is-left">
              <i class="fas fa-search"></i>
            </span>
          </div>
        </div>
      </div>
      <div class="column is-4">
        <button
          class="button is-primary is-medium is-fullwidth"
          onclick={() => (modalAgregarProducto = true)}
        >
          <span class="icon">
            <i class="fas fa-plus"></i>
          </span>
          <span>Agregar Producto</span>
        </button>
      </div>
    </div>
  
    <!-- Lista de productos -->
    <div class="columns">
      <div class="column is-8">
        <div class="box">
          <h2 class="title is-4">Productos Disponibles</h2>
          <div class="table-container">
            <table class="table is-fullwidth is-hoverable">
              <thead>
                <tr>
                  <th>Nombre</th>
                  <th>Precio</th>
                  <th>Disponible</th>
                  <th>Acciones</th>
                </tr>
              </thead>
              <tbody>
                {#each productosFiltrados as producto (producto.id)}
                  <tr>
                    <td>{producto.nombre}</td>
                    <td>${producto.precio.toFixed(2)}</td>
                    <td>{producto.cantidad}</td>
                    <td>
                      <button
                        class="button is-small is-success"
                        onclick={() => agregarAlCarrito(producto)}
                        disabled={producto.cantidad <= 0}
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
      <div class="column is-4">
        <div class="box">
          <h2 class="title is-4">Carrito de Venta</h2>
          {#if carrito.length === 0}
            <p class="has-text-centered py-4">El carrito está vacío</p>
          {:else}
            <div class="content">
              {#each carrito as item (item.id)}
                <div class="box is-shadowless mb-2">
                  <div class="is-flex is-justify-content-space-between">
                    <div>
                      <p class="has-text-weight-bold">{item.nombre}</p>
                      <p>${item.precio.toFixed(2)} c/u</p>
                    </div>
                    <div class="is-flex">
                        <input
                        class="input is-small"
                        type="number"
                        min="1"
                        max={item.cantidad}
                        bind:value={item.cantidadEnCarrito}
                        onchange={(e) => {
                          const target = e.target as HTMLInputElement;
                          if (target) {
                            ajustarCantidad(item.id, parseInt(target.value));
                          }
                        }}
                        style="width: 60px; margin-right: 8px;"
                      />
                      <button
                        class="button is-small is-danger"
                        onclick={() => eliminarDelCarrito(item.id)}
                      >
                        <span class="icon">
                          <i class="fas fa-trash"></i>
                        </span>
                      </button>
                    </div>
                  </div>
                  <p class="has-text-right">
                    Subtotal: ${(item.precio * item.cantidadEnCarrito).toFixed(2)}
                  </p>
                </div>
              {/each}
            </div>
  
            <hr />
  
            <div class="is-flex is-justify-content-space-between mb-4">
              <p class="has-text-weight-bold">Total:</p>
              <p class="has-text-weight-bold">${calcularTotal().toFixed(2)}</p>
            </div>
  
            <button class="button is-success is-fullwidth">
              <span class="icon">
                <i class="fas fa-cash-register"></i>
              </span>
              <span>Procesar Venta</span>
            </button>
          {/if}
        </div>
      </div>
    </div>
  
    <!-- Modal para agregar nuevo producto -->
    <div class="modal" class:is-active={modalAgregarProducto}>
      <div class="modal-background" onclick={() => (modalAgregarProducto = false)}></div>
      <div class="modal-card">
        <header class="modal-card-head">
          <p class="modal-card-title">Agregar Nuevo Producto</p>
          <button
            class="delete"
            aria-label="close"
            onclick={() => (modalAgregarProducto = false)}
          ></button>
        </header>
        <section class="modal-card-body">
          <div class="field">
            <label class="label">Nombre</label>
            <div class="control">
              <input
                class="input"
                type="text"
                placeholder="Nombre del producto"
                bind:value={nuevoProducto.nombre}
              />
            </div>
          </div>
          <div class="field">
            <label class="label">Precio</label>
            <div class="control">
              <input
                class="input"
                type="number"
                min="0"
                step="0.01"
                placeholder="Precio"
                bind:value={nuevoProducto.precio}
              />
            </div>
          </div>
          <div class="field">
            <label class="label">Cantidad Inicial</label>
            <div class="control">
              <input
                class="input"
                type="number"
                min="0"
                placeholder="Cantidad disponible"
                bind:value={nuevoProducto.cantidad}
              />
            </div>
          </div>
        </section>
        <footer class="modal-card-foot">
          <button class="button is-success" onclick={agregarNuevoProducto}>
            Guardar Producto
          </button>
          <button class="button" onclick={() => (modalAgregarProducto = false)}>
            Cancelar
          </button>
        </footer>
      </div>
    </div>
  </div>
  
  <style>
    .table-container {
      max-height: 60vh;
      overflow-y: auto;
    }
  </style>