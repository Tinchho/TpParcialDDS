

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Taxi {
	Ubicacion ubicacion
	EstadoTaxi estado
	
	def actualizarUbicacion(int latitud, int longitud){
		this.ubicacion.latitud = latitud
		this.ubicacion.longitud = longitud
	}
	
	def encontroClienteEnLaCalle(){
		this.estado = EstadoTaxi.Ocupado
	}
	
	def aceptarViaje(Viaje viaje){
		this.estado = EstadoTaxi.Ocupado
		viaje.aceptado(this)
	}
	
	def rechazarViaje(Viaje viaje){
		viaje.notificarSiguienteMasCercano(this)
	}
}