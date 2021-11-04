package cyou.wssy001.rdcspringbootdemo.service;

import cn.hutool.core.bean.BeanUtil;
import com.alibaba.fastjson.JSON;
import cyou.wssy001.rdcspringbootdemo.dto.EventDto;
import cyou.wssy001.rdcspringbootdemo.entity.EventType;
import cyou.wssy001.rdcspringbootdemo.entity.TakeOffEvent;
import cyou.wssy001.rdcspringbootdemo.handler.EventHandler;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

/**
 * @projectName: rdc-springboot-demo
 * @className: TakeOffEventService
 * @description: 处理起飞事件
 * @author: alexpetertyler
 * @date: 2021/4/13
 * @version: v1.0
 */
@Service
@Slf4j
public class TakeOffEventService implements EventHandler {
    @Override
    public void handle(EventType eventType, EventDto dto) {
        TakeOffEvent takeOffEvent = new TakeOffEvent();
        BeanUtil.copyProperties(dto, takeOffEvent);
        log.info("******TakeOffEvent" + JSON.toJSONString(takeOffEvent));
    }
}
