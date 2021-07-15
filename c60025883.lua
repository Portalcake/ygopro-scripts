--決闘竜 デュエル・リンク・ドラゴン
function c60025883.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c60025883.lcheck)
	c:EnableReviveLimit()
	--duel dragon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60025883,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,60025883)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(c60025883.spcon)
	e1:SetCost(c60025883.spcost)
	e1:SetTarget(c60025883.sptg)
	e1:SetOperation(c60025883.spop)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c60025883.tgcon)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end
function c60025883.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_SYNCHRO)
end
function c60025883.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c60025883.costfilter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemoveAsCost()
		and (c:IsSetCard(0xc2) or c:IsRace(RACE_DRAGON) and (c:IsLevel(7) or c:IsLevel(8)))
		and Duel.IsPlayerCanSpecialSummonMonster(tp,60025884,0,TYPES_TOKEN_MONSTER,c:GetAttack(),c:GetDefense(),c:GetLevel(),c:GetRace(),c:GetAttribute())
end
function c60025883.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60025883.costfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c60025883.costfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c60025883.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 and zone~=0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c60025883.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=bit.band(c:GetLinkedZone(tp),0x1f)
	local tc=e:GetLabelObject()
	local atk=tc:GetTextAttack()
	local def=tc:GetTextDefense()
	local lv=tc:GetOriginalLevel()
	local race=tc:GetOriginalRace()
	local att=tc:GetOriginalAttribute()
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,60025884,0,TYPES_TOKEN_MONSTER,atk,def,lv,race,att) then return end
	local token=Duel.CreateToken(tp,60025884)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP,zone)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	token:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(def)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	token:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e3:SetValue(att)
	token:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_LEVEL)
	e4:SetValue(lv)
	token:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CHANGE_RACE)
	e5:SetValue(race)
	token:RegisterEffect(e5)
	Duel.SpecialSummonComplete()
end
function c60025883.tgfilter(c)
	return c:GetOriginalCode()==60025884
end
function c60025883.tgcon(e)
	return Duel.IsExistingMatchingCard(c60025883.tgfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
