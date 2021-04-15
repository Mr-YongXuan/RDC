package cyou.wssy001.rdcspringbootdemo.entity;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * @projectName: rdc-springboot-demo
 * @className: BaseEvent
 * @description: 基本事件
 * @author: alexpetertyler
 * @date: 2021/4/13
 * @version: v1.0
 */
@Getter
@Setter
@ApiModel(description = "基本事件")
public class BaseEvent implements Serializable {
    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "事件名称", example = "takeoff")
    private String event;

    @ApiModelProperty(value = "玩家昵称", example = "A2A_Spawn_Init_NORM#001-02")
    private String playerName;

    @ApiModelProperty(value = "玩家唯一识别符", example = "AKJH-DASD-KGAS")
    private String playerUcid;

    public BaseEvent(EventType eventType, String playerName, String playerUcid) {
        this.event = eventType.getName();
        this.playerName = playerName;
        this.playerUcid = playerUcid;
    }
}
