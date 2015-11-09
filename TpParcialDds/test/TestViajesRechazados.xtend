import static org.mockito.Mockito.*;
import org.junit.Before
import org.junit.Test
import org.junit.After
import org.junit.Assert
import java.util.regex.Matcher
import org.mockito.internal.matchers.Matches

class TestViajesRechazados {
	var pasajero = new Cliente()
	var taxi1 = new Taxi()

	var zonaOeste = new Area()
	var capitalFdral = new Area()
	var moreno = new Ubicacion()
	var flores = new Ubicacion()
	var mockSistemaGeografico = mock(typeof(SistemaGeografico))
	var mockNotificador = mock(typeof(Notificador))

	@Before
	def void setUp() {
		pasajero.notificador = mockNotificador
		RepoTaxis.getInstance.sistemaGeo = mockSistemaGeografico

		taxi1.estado = EstadoTaxi.Libre

		RepoTaxis.getInstance.agregar(taxi1)

	}

	@After
	def void reinicarRepo() {
		RepoTaxis.reinicar
	}

	@Test
	def void TestNingunTaxiEnMiAreaSeRechazaViaje() {
		
		//Seteo lo que deberia devolver el sistema geografico
		when(mockSistemaGeografico.obtenerArea(any(Ubicacion))).thenReturn(zonaOeste).thenReturn(capitalFdral)
		
		var viaje = pasajero.solicitarViaje()

		//Verifico que ningun taxi esta en mi zona
		Assert.assertEquals(viaje.taxisPosibles.length, 0)

		//Verifico el estado del viaje
		Assert.assertEquals(viaje.estado, EstadoViaje.Rechazado)

		//Verifico que se notifique al cliente
		verify(mockNotificador, times(1)).notificarViajeRechazo(pasajero)
	}
	
	@Test
	def void TestHayUnTaxiEnMiZonaPeroRechaza(){
		when(mockSistemaGeografico.obtenerArea(any(Ubicacion))).thenReturn(zonaOeste).thenReturn(zonaOeste)
		
		var viaje = pasajero.solicitarViaje()

		//Verifico que hay un taxi en mi zona
		Assert.assertEquals(viaje.taxisPosibles.length, 1)
		
		//El taxi rechaza el viaje
		taxi1.rechazarViaje(viaje)
		
		//Verifico que se rechaza el viaje
		verify(mockNotificador, times(1)).notificarViajeRechazo(pasajero)
		Assert.assertEquals(viaje.estado, EstadoViaje.Rechazado)
	}

}
