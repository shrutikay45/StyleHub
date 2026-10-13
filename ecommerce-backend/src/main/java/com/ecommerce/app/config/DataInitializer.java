package com.ecommerce.app.config;

import com.ecommerce.app.entity.Coupon;
import com.ecommerce.app.entity.Role;
import com.ecommerce.app.entity.User;
import com.ecommerce.app.repository.CouponRepository;
import com.ecommerce.app.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;

@Component
@RequiredArgsConstructor
@Slf4j
public class DataInitializer implements CommandLineRunner {

    private final UserRepository userRepository;
    private final CouponRepository couponRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        // 1. Seed default Admin User if not exists
        final String adminEmail = "admin@stylehub.com";
        if (!userRepository.existsByEmail(adminEmail)) {
            User admin = new User();
            admin.setName("StyleHub Admin");
            admin.setEmail(adminEmail);
            admin.setPhone("9999999999");
            admin.setPasswordHash(passwordEncoder.encode("admin"));
            admin.setRole(Role.ADMIN);
            admin.setEmailVerified(true);
            admin.setPhoneVerified(true);
            userRepository.save(admin);
            log.info("Default Admin account created successfully: {} (Role: ADMIN)", adminEmail);
        } else {
            userRepository.findByEmail(adminEmail).ifPresent(user -> {
                if (user.getRole() != Role.ADMIN) {
                    user.setRole(Role.ADMIN);
                    userRepository.save(user);
                    log.info("Updated existing user {} to ROLE_ADMIN", adminEmail);
                }
            });
        }

        // 2. Seed Default Active Coupons into Database
        seedCouponIfNotExists("WELCOME50", "Get 50% off on your first order", Coupon.DiscountType.PERCENTAGE, 
                BigDecimal.valueOf(50.0), BigDecimal.valueOf(999.0), BigDecimal.valueOf(500.0));

        seedCouponIfNotExists("FLAT100", "Flat ₹100 discount on orders above ₹499", Coupon.DiscountType.FLAT, 
                BigDecimal.valueOf(100.0), BigDecimal.valueOf(499.0), BigDecimal.valueOf(100.0));

        seedCouponIfNotExists("FESTIVE20", "20% off on Ethnic & Party Wear collections", Coupon.DiscountType.PERCENTAGE, 
                BigDecimal.valueOf(20.0), BigDecimal.ZERO, BigDecimal.valueOf(1000.0));
    }

    private void seedCouponIfNotExists(String code, String description, Coupon.DiscountType type,
                                      BigDecimal discountValue, BigDecimal minOrderValue, BigDecimal maxDiscount) {
        if (couponRepository.findByCodeIgnoreCase(code).isEmpty()) {
            Coupon coupon = new Coupon();
            coupon.setCode(code);
            coupon.setDescription(description);
            coupon.setDiscountType(type);
            coupon.setDiscountValue(discountValue);
            coupon.setMinOrderValue(minOrderValue);
            coupon.setMaxDiscountAmount(maxDiscount);
            coupon.setActive(true);
            coupon.setUsageCount(0);
            couponRepository.save(coupon);
            log.info("Seeded coupon to database: {} ({} - {})", code, type, discountValue);
        }
    }
}
