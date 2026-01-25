package entities;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "ingrediente")
public class Ingrediente implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_ingrediente")
    private Long idIngrediente;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_receta", nullable = false)
    private Receta receta;

    @Column(name = "nombre", nullable = false, length = 200)
    private String nombre;

    @Column(name = "cantidad", nullable = false, length = 100)
    private String cantidad;

    @Column(name = "orden", nullable = false)
    private Integer orden = 0;

    // Constructors
    public Ingrediente() {
    }

    public Ingrediente(Receta receta, String nombre, String cantidad, Integer orden) {
        this.receta = receta;
        this.nombre = nombre;
        this.cantidad = cantidad;
        this.orden = orden;
    }

    // Getters and Setters
    public Long getIdIngrediente() {
        return idIngrediente;
    }

    public void setIdIngrediente(Long idIngrediente) {
        this.idIngrediente = idIngrediente;
    }

    public Receta getReceta() {
        return receta;
    }

    public void setReceta(Receta receta) {
        this.receta = receta;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getCantidad() {
        return cantidad;
    }

    public void setCantidad(String cantidad) {
        this.cantidad = cantidad;
    }

    public Integer getOrden() {
        return orden;
    }

    public void setOrden(Integer orden) {
        this.orden = orden;
    }

    @Override
    public String toString() {
        return "Ingrediente{id=" + idIngrediente + ", nombre='" + nombre + "', cantidad='" + cantidad + "'}";
    }
}