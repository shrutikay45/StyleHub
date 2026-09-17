package com.ecommerce.app.dto.response;

import com.ecommerce.app.entity.Product;
import lombok.Data;

import java.math.BigDecimal;
import java.time.Duration;
import java.time.Instant;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Data
public class ProductResponse {
    private UUID id;
    private String title;
    private String description;
    private String categoryName;
    private String brand;
    private BigDecimal price;
    private BigDecimal discountPrice;
    private Integer stock;
    private boolean featured;
    private boolean flashSale;
    private Instant flashSaleEndTime;
    private Long secondsRemaining;   // null if not a flash sale / no end time set / already ended
    private Double avgRating;
    private Integer reviewCount;
    private List<String> images;

    public static ProductResponse from(Product p) {
        ProductResponse r = new ProductResponse();
        r.setId(p.getId());
        r.setTitle(p.getTitle());
        r.setDescription(p.getDescription());
        r.setCategoryName(p.getCategory() != null ? p.getCategory().getName() : null);
        r.setBrand(p.getBrand());
        r.setPrice(p.getPrice());
        r.setDiscountPrice(p.getDiscountPrice());
        r.setStock(p.getStock());
        r.setFeatured(p.isFeatured());
        r.setFlashSale(p.isFlashSale());
        r.setFlashSaleEndTime(p.getFlashSaleEndTime());
        if (p.isFlashSale() && p.getFlashSaleEndTime() != null) {
            long remaining = Duration.between(Instant.now(), p.getFlashSaleEndTime()).getSeconds();
            r.setSecondsRemaining(Math.max(remaining, 0));
        }
        r.setAvgRating(p.getAvgRating());
        r.setReviewCount(p.getReviewCount());
        r.setImages(p.getImages().stream().map(i -> i.getUrl()).collect(Collectors.toList()));
        return r;
    }
}
