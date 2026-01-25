package rest.DTO;

import com.fasterxml.jackson.annotation.JsonInclude;
import entities.Inventario;

import java.util.List;

/**
 * DTO for Inventario entity.
 * Used for REST API response serialization.
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class InventarioDTO {

    private Long id;
    private String usuarioNombre;
    private String usuarioEmail;
    private List<AlimentoDTO> alimentos;
    private int totalAlimentos;

    // Constructors
    public InventarioDTO() {
    }

    /**
     * Creates a DTO from an Inventario entity.
     */
    public static InventarioDTO fromEntity(Inventario inventario, List<AlimentoDTO> alimentos) {
        if (inventario == null) {
            return null;
        }
        
        InventarioDTO dto = new InventarioDTO();
        dto.setId(inventario.getIdInventario());
        
        if (inventario.getUsuario() != null) {
            dto.setUsuarioNombre(inventario.getUsuario().getNombre());
            dto.setUsuarioEmail(inventario.getUsuario().getEmail());
        }
        
        dto.setAlimentos(alimentos);
        dto.setTotalAlimentos(alimentos != null ? alimentos.size() : 0);
        
        return dto;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsuarioNombre() {
        return usuarioNombre;
    }

    public void setUsuarioNombre(String usuarioNombre) {
        this.usuarioNombre = usuarioNombre;
    }

    public String getUsuarioEmail() {
        return usuarioEmail;
    }

    public void setUsuarioEmail(String usuarioEmail) {
        this.usuarioEmail = usuarioEmail;
    }

    public List<AlimentoDTO> getAlimentos() {
        return alimentos;
    }

    public void setAlimentos(List<AlimentoDTO> alimentos) {
        this.alimentos = alimentos;
        this.totalAlimentos = alimentos != null ? alimentos.size() : 0;
    }

    public int getTotalAlimentos() {
        return totalAlimentos;
    }

    public void setTotalAlimentos(int totalAlimentos) {
        this.totalAlimentos = totalAlimentos;
    }
}