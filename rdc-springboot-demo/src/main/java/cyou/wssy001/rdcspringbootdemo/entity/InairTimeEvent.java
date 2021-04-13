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
 * @className: InairTimeEvent
 * @description: 玩家制空事件
 * @author: alexpetertyler
 * @date: 2021/4/13
 * @version: v1.0
 */
@Setter
@Getter
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(description = "玩家制空事件")
public class InairTimeEvent extends BaseEvent implements Serializable {
    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "玩家制空时长", example = "0")
    private Double inairSecond;

    @ApiModelProperty(value = "玩家机型", example = "FA-18C_hornet")
    private String plane;

    public InairTimeEvent() {
        super(EventType.INAIR_TIME, null, null);

    }

    public InairTimeEvent(String playerName, String playerUcid, Double inairSecond, String plane) {
        super(EventType.INAIR_TIME, playerName, playerUcid);
        this.inairSecond = inairSecond;
        this.plane = plane;
    }
}
