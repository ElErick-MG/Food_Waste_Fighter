package entities;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "alimento")
public class Alimento implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_alimento")
    private Long idAlimento;

    @Column(name = "nombre", nullable = false, length = 100)
    private String nombre;

    @ManyToOne
    @JoinColumn(name = "id_categoria", nullable = false)
    private Categoria categoria;

    @Column(name = "fecha_caducidad", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date fechaCaducidad;

    @Column(name = "cantidad", nullable = false)
    private String cantidad;

    @ManyToOne
    @JoinColumn(name = "id_inventario", nullable = false)
    private Inventario inventario;

    public Alimento() {
    }

    public Alimento(String nombre, Categoria categoria, Date fechaCaducidad, String cantidad, Inventario inventario) {
        this.nombre = nombre;
        this.categoria = categoria;
        this.fechaCaducidad = fechaCaducidad;
        this.cantidad = cantidad;
        this.inventario = inventario;
    }

    public Long getIdAlimento() {
        return idAlimento;
    }

    public void setIdAlimento(Long idAlimento) {
        this.idAlimento = idAlimento;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public Categoria getCategoria() {
        return categoria;
    }

    public void setCategoria(Categoria categoria) {
        this.categoria = categoria;
    }

    public Date getFechaCaducidad() {
        return fechaCaducidad;
    }

    public void setFechaCaducidad(Date fechaCaducidad) {
        this.fechaCaducidad = fechaCaducidad;
    }

    public String getCantidad() {
        return cantidad;
    }

    public void setCantidad(String cantidad) {
        this.cantidad = cantidad;
    }

    public Inventario getInventario() {
        return inventario;
    }

    public void setInventario(Inventario inventario) {
        this.inventario = inventario;
    }
}
