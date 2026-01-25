package rest;

import jakarta.ws.rs.ApplicationPath;
import org.glassfish.jersey.server.ResourceConfig;

/**
 * JAX-RS Application configuration for REST API.
 * All REST endpoints will be available under /api/*
 */
@ApplicationPath("/api")
public class RestApplication extends ResourceConfig {

    public RestApplication() {
        // Register all REST resource classes in the 'rest' package
        packages("rest");
        
        // Register Jackson JSON provider for JSON serialization
        register(org.glassfish.jersey.jackson.JacksonFeature.class);
        
        System.out.println("Food Waste Fighter REST API initialized at /api/*");
    }
}