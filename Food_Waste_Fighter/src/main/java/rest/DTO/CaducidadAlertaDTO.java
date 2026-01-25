package rest.DTO;

import com.fasterxml.jackson.annotation.JsonInclude;

import java.util.List;

/**
 * DTO for expiration alerts response.
 * Groups alimentos by urgency level.
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class CaducidadAlertaDTO {

    private List<AlimentoDTO> criticos;      // 1-2 days (red)
    private List<AlimentoDTO> advertencia;   // 3-5 days (yellow)
    private List<AlimentoDTO> normales;      // 6+ days (gray)
    
    private int totalCriticos;
    private int totalAdvertencia;
    private int totalNormales;

    // Constructors
    public CaducidadAlertaDTO() {
    }

    public CaducidadAlertaDTO(List<AlimentoDTO> criticos, List<AlimentoDTO> advertencia, List<AlimentoDTO> normales) {
        this.criticos = criticos;
        this.advertencia = advertencia;
        this.normales = normales;
        this.totalCriticos = criticos != null ? criticos.size() : 0;
        this.totalAdvertencia = advertencia != null ? advertencia.size() : 0;
        this.totalNormales = normales != null ? normales.size() : 0;
    }

    // Getters and Setters
    public List<AlimentoDTO> getCriticos() {
        return criticos;
    }

    public void setCriticos(List<AlimentoDTO> criticos) {
        this.criticos = criticos;
        this.totalCriticos = criticos != null ? criticos.size() : 0;
    }

    public List<AlimentoDTO> getAdvertencia() {
        return advertencia;
    }

    public void setAdvertencia(List<AlimentoDTO> advertencia) {
        this.advertencia = advertencia;
        this.totalAdvertencia = advertencia != null ? advertencia.size() : 0;
    }

    public List<AlimentoDTO> getNormales() {
        return normales;
    }

    public void setNormales(List<AlimentoDTO> normales) {
        this.normales = normales;
        this.totalNormales = normales != null ? normales.size() : 0;
    }

    public int getTotalCriticos() {
        return totalCriticos;
    }

    public int getTotalAdvertencia() {
        return totalAdvertencia;
    }

    public int getTotalNormales() {
        return totalNormales;
    }
}