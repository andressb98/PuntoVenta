<script lang="ts">
  // Datos de ejemplo - en la implementación real estos vendrían de tu store o API
  let employerProfile = {
      name: "Juan Pérez",
      company: "Constructora Pérez S.A.",
      rating: 4.5,
      completedProjects: 12,
      activeRequests: 3,
      unreadMessages: 5
  };

  let recentRequests = [
      { id: 1, title: "Diseño de casa moderna", category: "Arquitectura", date: "2023-05-15", status: "En revisión" },
      { id: 2, title: "Reparación de tuberías", category: "Plomería", date: "2023-05-10", status: "En progreso" },
      { id: 3, title: "Instalación eléctrica", category: "Electricidad", date: "2023-05-05", status: "Pendiente" }
  ];

  let recentMessages = [
      { id: 1, from: "Carlos Gómez", subject: "Cotización proyecto", preview: "Hola, te envío la cotización solicitada...", read: false },
      { id: 2, from: "María Rodríguez", subject: "Consulta sobre diseño", preview: "Tengo algunas preguntas sobre el diseño...", read: true }
  ];
</script>

<div class="container">
  <!-- Resumen rápido -->
  <div class="columns">
      <div class="column is-4">
          <div class="box">
              <div class="media">
                  <div class="media-left">
                      <figure class="image is-64x64">
                          <img src="/perfil/1743556814005.jpg" alt="Perfil" class="is-rounded">
                      </figure>
                  </div>
                  <div class="media-content">
                      <p class="title is-4">{employerProfile.name}</p>
                      <p class="subtitle is-6">{employerProfile.company}</p>
                      <div class="rating">
                          <span class="icon has-text-warning">
                              {#each Array(5) as _, i}
                                  <i class="fas fa-star {i < Math.floor(employerProfile.rating) ? 'has-text-warning' : (i === Math.floor(employerProfile.rating) && employerProfile.rating % 1 >= 0.5 ? 'fa-star-half-alt has-text-warning' : 'far fa-star has-text-warning-light')}"></i>
                              {/each}
                          </span>
                          <span>({employerProfile.rating})</span>
                      </div>
                  </div>
              </div>
              <hr>
              <div class="stats">
                  <div class="stat">
                      <p class="heading">Ventas</p>
                      <p class="title is-5">{employerProfile.completedProjects}</p>
                  </div>
                  <div class="stat">
                      <p class="heading">Creditos</p>
                      <p class="title is-5">{employerProfile.activeRequests}</p>
                  </div>
                  <div class="stat">
                      <p class="heading">Efectivo</p>
                      <p class="title is-5">{employerProfile.unreadMessages}</p>
                  </div>
              </div>
              <a href="/employer/profile" class="button is-fullwidth is-info">
                  Ver perfil completo
              </a>
          </div>
      </div>

      <div class="column is-8">
          <!-- Últimas solicitudes -->
          <div class="box">
              <div class="level">
                  <div class="level-left">
                      <h2 class="title is-4">Ventas Reciente</h2>
                  </div>
                  <div class="level-right">
                      <a href="/employer/requests" class="button is-small is-link">
                          Ver todas
                      </a>
                  </div>
              </div>
              
              <div class="content">
                  <table class="table is-fullwidth is-hoverable">
                      <thead>
                          <tr>
                              <th>Folio</th>
                              <th>Importe</th>
                              <th>Fecha</th>
                              <th>Hora</th>
                              <th>Acciones</th>
                          </tr>
                      </thead>
                      <tbody>
                          {#each recentRequests as request}
                              <tr>
                                  <td>{request.title}</td>
                                  <td>{request.category}</td>
                                  <td>{request.date}</td>
                                  <td>
                                      <span class="tag {request.status === 'En progreso' ? 'is-warning' : request.status === 'Pendiente' ? 'is-danger' : 'is-info'}">
                                          {request.status}
                                      </span>
                                  </td>
                                  <td>
                                      <a href={`/employer/requests/${request.id}`} class="button is-small is-info is-outlined">
                                          Ver detalles
                                      </a>
                                  </td>
                              </tr>
                          {/each}
                      </tbody>
                  </table>
              </div>
          </div>

          <!-- Mensajes recientes -->
          <div class="box">
              <div class="level">
                  <div class="level-left">
                      <h2 class="title is-4">Mensajes recientes</h2>
                  </div>
                  <div class="level-right">
                      <a href="/employer/messages" class="button is-small is-link">
                          Ver todos
                      </a>
                  </div>
              </div>
              
              <div class="content">
                  {#each recentMessages as message}
                      <article class="message {message.read ? '' : 'is-info'}">
                          <div class="message-header">
                              <p>{message.from}</p>
                              {#if !message.read}
                                  <span class="tag is-info">Nuevo</span>
                              {/if}
                          </div>
                          <div class="message-body">
                              <p class="has-text-weight-bold">{message.subject}</p>
                              <p>{message.preview}</p>
                              <a href={`/employer/messages/${message.id}`} class="button is-small is-link is-outlined">
                                  Leer mensaje
                              </a>
                          </div>
                      </article>
                  {/each}
              </div>
          </div>
      </div>
  </div>
</div>

<style>
  .stats {
      display: flex;
      justify-content: space-around;
      text-align: center;
      margin: 1.5rem 0;
  }
  
  .stat {
      padding: 0 1rem;
  }
  
  .stat .heading {
      font-size: 0.8rem;
      color: #7a7a7a;
  }
  
  .rating {
      margin-top: 0.5rem;
  }
  
  .message {
      margin-bottom: 1rem;
  }
  
  .message:last-child {
      margin-bottom: 0;
  }
  
  .table {
      margin-top: 1rem;
  }
</style>