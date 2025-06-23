import wollok.vm.*
class Paciente {
  const property rutina = []
  const property edad
  var property fortalezaDolor
  var property fortalezaMuscular

  method puedeUsarAparato(unAparato) = unAparato.puedeSerUsado(self)
  method agregarAparatoARutina(unAparato) {rutina.add(unAparato)}
  method usarAparato(unAparato){
    unAparato.usoDelAparato(self)
  }
  method fortalezaDolor(unValor) {
    fortalezaDolor -= unValor
  }
  method fortalezaMuscular(unValor) {
    fortalezaMuscular += unValor
  }
  method puedeHacerRutina() = rutina.all({a => a.puedeSerUsado(self)})
  method hacerRutina(valorObjeto) {
    if (self.puedeHacerRutina()){
      rutina.forEach({a => a.usoDelAparato(self)})
    }
  }
}

class Aparato {
  const property color
  method usoDelAparato(paciente)
  method puedeSerUsado(paciente)
  method hacerMantenimiento()
  method necesitaMantenimiento()
}

class Magneto inherits Aparato {
  var imantacion = 800

  override method usoDelAparato(paciente) {
    paciente.fortalezaDolor(paciente.fortalezaDolor() * 0.1)
    imantacion = (imantacion - 1).max(0)
  }

  override method puedeSerUsado(paciente) = true

  override method hacerMantenimiento(){
    if (imantacion < 100){
      imantacion = (imantacion + 500).min(800)
    }
  }

  override method necesitaMantenimiento() = imantacion < 100
}

class Bicicleta inherits Aparato {
  var desajustesTornillos = 0
  var pierdeAceite = 0

  override method usoDelAparato(paciente) {
    if (paciente.edad() > 8) {
      paciente.fortalezaDolor(4)
      paciente.fortalezaMuscular(3)
    }
    if (paciente.fortalezaDolor() > 30){
      desajustesTornillos += 1
    }else if (paciente.fortalezaDolor() > 30 and paciente.edad().between(30, 50)){
      desajustesTornillos += 1
      pierdeAceite += 1
    }
  }
  override method puedeSerUsado(paciente) = paciente.edad() > 8

  override method hacerMantenimiento() {
    if (desajustesTornillos >= 10 or pierdeAceite >= 5){
      desajustesTornillos = 0
      pierdeAceite = 0
    }
  }

  override method necesitaMantenimiento() = desajustesTornillos >= 10 or pierdeAceite >= 5
}

class Minitramp inherits Aparato {
  override method usoDelAparato(paciente) {
    if (paciente.fortalezaDolor() < 20) {
      paciente.fortalezaMuscular(paciente.edad() * 0.1)
    }
  }
  override method puedeSerUsado(paciente) = paciente.fortalezaDolor() < 20
  override method hacerMantenimiento() {}
  override method necesitaMantenimiento() = false
}

class Resistente inherits Paciente {
  override method hacerRutina(valorObjeto) {
      super(valorObjeto)
      self.fortalezaMuscular(rutina.size())
  }
}

class Caprichoso inherits Paciente {
  override method puedeHacerRutina() = super() and rutina.any({a => a.color() == "Rojo"})
  override method hacerRutina(valorObjeto) {
    if (not self.puedeHacerRutina()){
      self.error("Una de las maquinas no es Roja")
    }
    else {
      super(valorObjeto)
      super(valorObjeto)
    }
  }
}

class RapidaRecuperacion inherits Paciente {
  override method hacerRutina(valorObjeto) {
      super(valorObjeto)
      self.fortalezaDolor(valorObjeto.valor())
  }
}

object valorRapidaRecu {
  var property valor = 3
}

object kinesiologia {
  const aparatos = []
  const pacientes = #{}

  method agregarPaciente(unPaciente){pacientes.add(unPaciente)}
  method agregarAParato(unAparato){aparatos.add(unAparato)}
  method coloresDeLosAparatos() = aparatos.map({a => a.color()})
  method pacientesMenoresA8Años() = pacientes.filter({p => p.edad() < 8})
  method cantidadPacientesNoPuedenHacerSesion() = pacientes.sum({p => not p.puedeHacerRutina()})
  method estaEnCondiciones() = aparatos.all({a => not a.necesitaMantenimiento()})
  method cantidadNecesitanService() = aparatos.filter({a => a.necesitaMantenimiento()}).size()
  method estaComplicado() = self.cantidadNecesitanService() >= aparatos.size() / 2
  method visitaTecnico() {
    aparatos.forEach({a => a.hacerMantenimiento()})
  }
}

