import static org.mockito.Mockito.*;
import org.junit.Before
import org.junit.Test
import org.junit.After
import org.junit.Assert
import java.util.regex.Matcher
import org.mockito.internal.matchers.Matches

class TestViajesAceptados {
	var pasajero = new Cliente()
	var taxi1 = new Taxi()
	var taxi2 = new Taxi()
	var taxi3 = new Taxi()
	var granBsAs = new Area()
	var zonaOeste = new Area()
	var capitalFdral = new Area()
	var moreno = new Ubicacion()
	var pasoDelRey = new Ubicacion()
	var flores = new Ubicacion()
	var mockSistemaGeografico = mock(typeof(SistemaGeografico))
	var mockNotificador = mock(typeof(Notificador))

	@Before
	def void setUp() {
		pasajero.notificador = mockNotificador
		RepoTaxis.getInstance.sistemaGeo = mockSistemaGeografico

		zonaOeste.padre = granBsAs

		taxi1.estado = EstadoTaxi.Libre
		taxi2.estado = EstadoTaxi.Libre
		taxi3.estado = EstadoTaxi.Libre

		RepoTaxis.getInstance.agregar(taxi1)
		RepoTaxis.getInstance.agregar(taxi2)
		RepoTaxis.getInstance.agregar(taxi3)

		//Seteo lo que deberia devolver el sistema geografico
		//Para el filter el taxi1 y el pasajero son de zonaOeste igual para el 2
		//Para el taxi3 es de cap federal y el usuario de zonOeste
		when(mockSistemaGeografico.obtenerArea(any(Ubicacion))).thenReturn(zonaOeste).thenReturn(zonaOeste).
			thenReturn(zonaOeste).thenReturn(zonaOeste).thenReturn(capitalFdral).thenReturn(zonaOeste)
		//Aca devuelvo que el mas cercano es el taxi2
		when(mockSistemaGeografico.distanciaEntre(any(Ubicacion), any(Ubicacion))).thenReturn(5).thenReturn(10)
	}

	@After
	def void reinicarRepo() {
		RepoTaxis.reinicar
	}

	@Test
	def void TestClientePideViaje() {
		var viaje = pasajero.solicitarViaje()
		verify(mockNotificador, times(1)).notificarNuevoViaje(any(Taxi), any(Viaje))
	}

	@Test
	def void TestClientePideViajeYAceptaUnTaxi() {
		var viaje = pasajero.solicitarViaje()
		taxi2.aceptarViaje(viaje)
		
		//Verfico que se notifico al cliente que se acepto el viaje
		verify(mockNotificador, times(1)).notificarViajeAceptado(pasajero, viaje)
		
		//Verifico el estado del viaje
		Assert.assertEquals(viaje.estado,EstadoViaje.Aceptado)
		
		//Verfico que el taxi ahora se encuentra ocupado
		Assert.assertEquals(taxi2.estado,EstadoTaxi.Ocupado)
	}

	@Test
	def void TestClientePideViajeYRechazaTaxi2yAceptaTaxi1() {
		var viaje = pasajero.solicitarViaje()
		
		//Verifico que haya solo 2 de los 3 taxis estan en mi area
		Assert.assertEquals(viaje.taxisPosibles.length, 2)
		
		//Verfico que la lista en este en orden, el mas cercano era el taxi2 como dije antes
		Assert.assertEquals(viaje.taxisPosibles.get(0), taxi2)
		Assert.assertEquals(viaje.taxisPosibles.get(1), taxi1)
		
		//Verfico que se haya notificado al taxi2 primero
		verify(mockNotificador, times(1)).notificarNuevoViaje(taxi2, viaje)
		
		//Taxi2 rechaza y se verifca que se notifique al taxi1 que es el siguiente mas cercano
		taxi2.rechazarViaje(viaje)
		verify(mockNotificador, times(1)).notificarNuevoViaje(taxi1, viaje)
		
		//Taxi1 acepta el viaje y verifico que se notifique al cliente
		taxi1.aceptarViaje(viaje)
		verify(mockNotificador, times(1)).notificarViajeAceptado(pasajero, viaje)
		Assert.assertEquals(viaje.taxisPosibles.length,1)

	}
	

}
