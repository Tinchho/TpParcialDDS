import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import java.util.ArrayList

@Accessors
class Viaje {
	Cliente pasajero
	Taxi taxista
	double costo
	EstadoViaje estado
	List<Taxi> taxisPosibles = new ArrayList<Taxi>()

	new(Cliente cliente) {
		this.pasajero = cliente
		this.estado = EstadoViaje.Solicitado
		this.taxisPosibles = RepoTaxis.getInstance.obtenerTaxisEnAreaOrdenados(pasajero)
		this.notificarTaxiMasCercano()
	}

	def void notificarTaxiMasCercano() {
		if (!(taxisPosibles.length == 0)) {
			taxisPosibles.get(0).notificarNuevoViaje(this)
		} else {
			this.estado = EstadoViaje.Rechazado
			this.pasajero.notificarViajeRechazado()
		}
	}

	def aceptado(Taxi taxiQueAcepto) {
		this.estado = EstadoViaje.Aceptado
		this.taxista = taxiQueAcepto
		this.pasajero.notificarViajeAceptado()
	}

	def ubicacionTaxi() {
		return taxista.ubicacion
	}

	def cancelarTaxi() {
		this.estado = EstadoViaje.Cancelado
		this.pasajero.notificarCancelacion()
	}

	def cancelarPasajero() {

		if (this.estado == EstadoViaje.Aceptado) {
			this.taxista.notificarCancelacion()
		}

		this.estado = EstadoViaje.Cancelado
	}
}
