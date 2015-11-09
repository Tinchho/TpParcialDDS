import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import java.util.ArrayList

@Accessors
class Viaje {
	Cliente pasajero
	Taxi taxista
	double costo
	EstadoViaje estado
	Notificador notificador
	List<Taxi> taxisPosibles = new ArrayList<Taxi>()

	new(Cliente cliente) {
		this.pasajero = cliente
		this.estado = EstadoViaje.Solicitado

		//FIXME aca le hago llegar el mock
		this.notificador = cliente.notificador
		this.notificarTaxiMasCercano()
	}

	def notificarTaxiMasCercano() {
		this.taxisPosibles = RepoTaxis.getInstance.obtenerTaxisEnAreaOrdenados(pasajero)
		if (!(taxisPosibles.length == 0)) {
			notificador.notificarNuevoViaje(taxisPosibles.get(0), this)
		} else {
			this.estado = EstadoViaje.Rechazado
			notificador.notificarViajeRechazo(pasajero)
		}
	}

	def notificarSiguienteMasCercano(Taxi taxiQueRechazo) {
		taxisPosibles.remove(taxiQueRechazo)
		if (!taxisPosibles.empty) {
			notificador.notificarNuevoViaje(taxisPosibles.get(0), this)
		} else {
			this.estado = EstadoViaje.Rechazado
			notificador.notificarViajeRechazo(pasajero)
		}
	}

	def aceptado(Taxi taxiQueAcepto) {
		this.estado = EstadoViaje.Aceptado
		this.taxista = taxiQueAcepto
		notificador.notificarViajeAceptado(pasajero, this)
	}

	def ubicacionTaxi() {
		return taxista.ubicacion
	}

	def cancelarTaxi() {
		this.estado = EstadoViaje.Cancelado
		notificador.notificarCancelacionACliente(pasajero)
	}

	def cancelarPasajero() {

		if (this.estado == EstadoViaje.Aceptado) {
			notificador.notificarCancelacionATaxi(taxista)
		}

		this.estado = EstadoViaje.Cancelado
	}
}
