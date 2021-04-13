package cyou.wssy001.rdcspringbootdemo.entity;

import io.swagger.annotations.ApiModel;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

/**
 * @projectName: rdc-springboot-demo
 * @className: DisconnectEvent
 * @description: 玩家断开连接事件
 * @author: alexpetertyler
 * @date: 2021/4/13
 * @version: v1.0
 */
@Setter
@Getter
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(description = "玩家断开连接事件")
public class DisconnectEvent extends BaseEvent implements Serializable {
    private static final long serialVersionUID = 1L;

    public DisconnectEvent() {
        super(EventType.DISCONNECT, null, null);

    }

    public DisconnectEvent(String playerName, String playerUcid) {
        super(EventType.DISCONNECT, playerName, playerUcid);
    }
}
