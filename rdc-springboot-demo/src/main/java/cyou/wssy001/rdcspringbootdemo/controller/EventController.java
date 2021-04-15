package cyou.wssy001.rdcspringbootdemo.controller;

import com.alibaba.fastjson.JSON;
import cyou.wssy001.rdcspringbootdemo.dto.EventDto;
import cyou.wssy001.rdcspringbootdemo.service.DCSEventDispatchService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.context.request.async.WebAsyncTask;
import springfox.documentation.spring.web.json.Json;

import java.util.concurrent.Callable;

/**
 * @projectName: rdc-springboot-demo
 * @className: EventController
 * @description: 事件Controller
 * @author: alexpetertyler
 * @date: 2021/4/12
 * @version: v1.0
 */
@RestController
@RequestMapping("/rdc/api/v1")
@RequiredArgsConstructor
@Slf4j
@Api(tags = "事件Controller")
public class EventController {

    private final DCSEventDispatchService dcsEventDispatchService;

    @PostMapping("/dataPort")
    @ApiOperation("接收事件")
    public WebAsyncTask<String> receive(
            @RequestParam String data
    ) {
        EventDto eventDto = JSON.parseObject(data, EventDto.class);
        Callable<String> callable = () -> {
            dcsEventDispatchService.dispatch(eventDto);
            return "成功";
        };

        // 指定3s的超时
        WebAsyncTask<String> webTask = new WebAsyncTask<>(3000, callable);

        webTask.onTimeout(() -> {
            log.info("******超时返回");
            return "超时返回!!!";
        });

        webTask.onError(() -> {
            log.info("******异常返回");
            return "异常返回";
        });

        return webTask;
    }
}
