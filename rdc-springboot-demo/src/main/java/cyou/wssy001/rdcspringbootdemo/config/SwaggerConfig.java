package cyou.wssy001.rdcspringbootdemo.config;

import com.github.xiaoymin.knife4j.spring.extension.OpenApiExtensionResolver;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.service.Contact;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2WebMvc;

/**
 * @projectName: graduation-project
 * @className: SwaggerConfig
 * @description:
 * @author: alexpetertyler
 * @date: 2020/9/4
 * @Version: v1.0
 */
@Configuration
@EnableSwagger2WebMvc
@RequiredArgsConstructor
public class SwaggerConfig implements WebMvcConfigurer {
//    private final Environment environment;

    private final OpenApiExtensionResolver openApiExtensionResolver;

    @Bean
    public Docket docket() {
        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo())
//                .enable(checkEnvironment())
                .groupName("默认分组")
                .select()
                .apis(RequestHandlerSelectors.basePackage("cyou.wssy001.rdcspringbootdemo.controller"))
                .paths(PathSelectors.any())
                .build()
                .extensions(openApiExtensionResolver.buildSettingExtensions());
    }

    private ApiInfo apiInfo() {
        Contact contact = new Contact("Tyler", "", "");
        return new ApiInfoBuilder()
                .contact(contact)
                .title("RDC Java demo API Doc")
                .description("方便快速上手")
                .version("v1.0")
                .build();
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("doc.html").addResourceLocations("classpath:/META-INF/resources/");
        registry.addResourceHandler("/webjars/**").addResourceLocations("classpath:/META-INF/resources/webjars/");
    }

//    检查当前项目运行环境
//    private boolean checkEnvironment() {
//        return StrUtil.containsAnyIgnoreCase(environment.getActiveProfiles()[0], "dev", "test");
//    }
}
