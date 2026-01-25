package rest.DTO;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import entities.Alimento;

import java.util.Date;

/**
 * Data Transfer Object for Alimento entity.
 * Used for REST API request/response serialization.
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class AlimentoDTO {

    private Long id;
    private String nombre;
    private Long idCategoria;
    private String categoriaNombre;
    
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private Date fechaCaducidad;
    
    private String cantidad;

    // Constructors
    public AlimentoDTO() {
    }

    /**
     * Creates a DTO from an Alimento entity.
     */
    public static AlimentoDTO fromEntity(Alimento alimento) {
        if (alimento == null) {
            return null;
        }
        
        AlimentoDTO dto = new AlimentoDTO();
        dto.setId(alimento.getIdAlimento());
        dto.setNombre(alimento.getNombre());
        dto.setFechaCaducidad(alimento.getFechaCaducidad());
        dto.setCantidad(alimento.getCantidad());
        
        if (alimento.getCategoria() != null) {
            dto.setIdCategoria(alimento.getCategoria().getIdCategoria());
            dto.setCategoriaNombre(alimento.getCategoria().getNombre());
        }
        
        return dto;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public Long getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(Long idCategoria) {
        this.idCategoria = idCategoria;
    }

    public String getCategoriaNombre() {
        return categoriaNombre;
    }

    public void setCategoriaNombre(String categoriaNombre) {
        this.categoriaNombre = categoriaNombre;
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
}