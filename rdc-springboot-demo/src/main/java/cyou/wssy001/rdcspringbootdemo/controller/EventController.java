package cyou.wssy001.rdcspringbootdemo.controller;

import cyou.wssy001.rdcspringbootdemo.dto.EventDto;
import cyou.wssy001.rdcspringbootdemo.service.DCSEventDispatchService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.async.WebAsyncTask;

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
            @RequestBody EventDto eventDto
    ) {

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
