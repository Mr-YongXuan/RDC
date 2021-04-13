package cyou.wssy001.rdcspringbootdemo.handler;

import cyou.wssy001.rdcspringbootdemo.dto.EventDto;
import cyou.wssy001.rdcspringbootdemo.entity.EventType;

/**
 * @projectName: rdc-springboot-demo
 * @className: BaseHandler
 * @description:
 * @author: alexpetertyler
 * @date: 2021/4/12
 * @version: v1.0
 */
public interface EventHandler {
    void handle(EventType eventType, EventDto eventDto);
}
