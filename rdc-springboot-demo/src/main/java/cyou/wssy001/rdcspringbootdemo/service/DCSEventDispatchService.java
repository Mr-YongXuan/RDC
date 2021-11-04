package cyou.wssy001.rdcspringbootdemo.service;

import cyou.wssy001.rdcspringbootdemo.dto.EventDto;
import cyou.wssy001.rdcspringbootdemo.entity.EventType;
import cyou.wssy001.rdcspringbootdemo.handler.EventHandler;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * @projectName: rdc-springboot-demo
 * @className: DCSEventDispatchService
 * @description: 事件分发
 * @author: alexpetertyler
 * @date: 2021/4/12
 * @version: v1.0
 */
@Service
public class DCSEventDispatchService implements AutoCloseable {
    private Map<EventType, EventHandler> handlers = new ConcurrentHashMap<>();

    public void bind(EventType eventType, EventHandler eventHandler) {
        handlers.put(eventType, eventHandler);
    }

    public void dispatch(EventDto eventDto) {
        EventType eventType = EventType.getTypeByName(eventDto.getEvent());
        handlers.get(eventType).handle(eventType, eventDto);
    }

    @Override
    public void close() throws Exception {

    }
}
