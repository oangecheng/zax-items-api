local medal_skins =
{
    medal_statue_marble_gugugu = {--大帅鸽雕像
		sort_num=1,--排序编号
		skin_info={
			{--合家欢乐
				id=1,
				price=68,
				name=STRINGS.MEDAL_SKIN_NAME.MEDAL_STATUE_GUGUGU_SKIN2,
				reskin_fn=function(inst)
					inst.AnimState:OverrideSymbol("swap_statue", "medal_statue_gugugu_skin2", "swap_statue")
				end,
				image="medal_statue_gugugu_skin2",
			},
			{--鸽王之王
				id=2,--皮肤ID(非唯一ID,仅用于区分同一预制物)
				price=28,--价格
				name=STRINGS.MEDAL_SKIN_NAME.MEDAL_STATUE_GUGUGU_SKIN1,
				reskin_fn=function(inst)
					inst.AnimState:OverrideSymbol("swap_statue", "medal_statue_gugugu_skin1", "swap_statue")
				end,
				image="medal_statue_gugugu_skin1",--展示用贴图
			},
			{--冰雕玉琢
				id=3,
				price=168,
				name=STRINGS.MEDAL_SKIN_NAME.MEDAL_STATUE_GUGUGU_SKIN3,
				reskin_fn=function(inst)
					inst.AnimState:OverrideSymbol("swap_statue", "medal_statue_gugugu_skin3", "swap_statue")
				end,
				image="medal_statue_gugugu_skin3",
			},
		},
		initskin_fn=function(inst)--原皮数据的应用函数(皮肤法杖切回原皮肤的时候需要执行)
			inst.AnimState:OverrideSymbol("swap_statue", "medal_statue_gugugu", "swap_statue")
		end,
		fx_data={y=0.5,scale=1.2},--特效参数(特效名、尺寸、偏移等)
	},
}

return medal_skins
