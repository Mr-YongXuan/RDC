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
 * @className: GameTimeEvent
 * @description: 玩家游戏时长事件
 * @author: alexpetertyler
 * @date: 2021/4/13
 * @version: v1.0
 */
@Setter
@Getter
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(description = "玩家游戏时长事件")
public class GameTimeEvent extends BaseEvent implements Serializable {
    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "玩家在服务器游玩总时长", example = "241")
    private Double totalSecond;

    public GameTimeEvent() {
        super(EventType.GAME_TIME, null, null);

    }

    public GameTimeEvent(Double totalSecond, String playerName, String playerUcid) {
        super(EventType.GAME_TIME, playerName, playerUcid);
        this.totalSecond = totalSecond;
    }
}
