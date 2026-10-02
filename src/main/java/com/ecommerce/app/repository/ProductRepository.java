package com.ecommerce.app.repository;

import com.ecommerce.app.entity.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.List;
import java.util.UUID;

public interface ProductRepository extends JpaRepository<Product, UUID>, JpaSpecificationExecutor<Product> {

    @Override
    @EntityGraph(attributePaths = {"category", "images"})
    Page<Product> findAll(Specification<Product> spec, Pageable pageable);

    @EntityGraph(attributePaths = {"category", "images"})
    List<Product> findByFeaturedTrueAndActiveTrue();

    @EntityGraph(attributePaths = {"category", "images"})
    List<Product> findByFlashSaleTrueAndActiveTrue();

    @EntityGraph(attributePaths = {"category", "images"})
    List<Product> findByCategoryIdAndActiveTrue(UUID categoryId);

    @EntityGraph(attributePaths = {"category", "images"})
    List<Product> findTop10ByActiveTrueOrderByCreatedAtDesc();
}
