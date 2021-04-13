package cyou.wssy001.rdcspringbootdemo.entity;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

/**
 * @projectName: rdc-springboot-demo
 * @className: ConnectEvent
 * @description: 玩家连接事件
 * @author: alexpetertyler
 * @date: 2021/4/13
 * @version: v1.0
 */
@Setter
@Getter
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(description = "玩家连接事件")
public class ConnectEvent extends BaseEvent implements Serializable {
    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "玩家IP地址", example = "1.2.3.4:12631")
    private String playerIpaddr;

    public ConnectEvent() {
        super(EventType.CONNECT, null, null);

    }

    public ConnectEvent(String playerName, String playerUcid, String playerIpaddr) {
        super(EventType.CONNECT, playerName, playerUcid);
        this.playerIpaddr = playerIpaddr;
    }
}
