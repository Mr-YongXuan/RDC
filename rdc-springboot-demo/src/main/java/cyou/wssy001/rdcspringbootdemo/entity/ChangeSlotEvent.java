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
 * @className: ChangeSlotEvent
 * @description: 玩家切换阵营事件
 * @author: alexpetertyler
 * @date: 2021/4/13
 * @version: v1.0
 */
@Setter
@Getter
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(description = "玩家切换阵营事件")
public class ChangeSlotEvent extends BaseEvent implements Serializable {
    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "切换席位前选择的阵营 0:观众席 1:红方 2:蓝方", example = "1")
    private Integer prevSide;

    @ApiModelProperty(value = "当前席位id", example = "403")
    private String soltId;

    public ChangeSlotEvent() {
        super(EventType.CHANGE_SLOT, null, null);

    }

    public ChangeSlotEvent(String playerName, String playerUcid, Integer prevSide, String soltId) {
        super(EventType.CHANGE_SLOT, playerName, playerUcid);
        this.prevSide = prevSide;
        this.soltId = soltId;
    }
}
