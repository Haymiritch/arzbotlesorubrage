-- много кода который не воздействуется в скрипте, не срите под тему тем что говнокода больше чем обычного кода, пожалуйста
-- работает не сильно стабильно НО РАБОТАЕТ!!!
-- куча функций которые повторяются не пойми кода, это тоже пропустите
-- делал скрипт очень лениво, впервые вспомнил про самп и луа с 03 месяца 2023 года

require("addon") -- плагины
local sampev = require("samp.events")

local referal = 'Sam_Mason' -- ник пригласившего
local password = '123123123' -- пароль от акков

local timestep = 50 -- в миллисекундах, задержка между телепортом (по умолчанию 50)
local step = 2 -- в метрах, шаг телепорта (по умолчанию 2)

local ustr, razdv, benzp, derevo = 0 -- этап работы 

--------------------------------------------------------------------------------------

function onCoordStop() -- функция после того как коордмастер окончил работу
	newTask(function()
		wait(2000)
		sendKey(1024)
		wait(2000)
		sendKey(1024)
		if derevo == 1 then
			derevo = 0
			wait(15000)
			rabota_zdatdervo()
		end		
	end)
end

function printm(text) -- функция для вывода сообщения в чат с маркой
	print("[Lesovoz]: " .. text)
end

function rabota_ustr() -- функция что-бы устроится на работу (и не устроится)
	printm("Бежим устраиватся на работу!")
	ustr = 3
	coordStart(-554.31585693359, -173.51475524902, 78.430854797363, timestep, step, true) -- коордмастер к устроиству
end

function rabota_razdv() -- функция что-бы пройти на раздевалку и начать работу
	printm("Бежим переодеватся!")
	razdv = 1
	ustr = 5
	coordStart(-535.1162109375, -175.99670410156, 78.430854797363, timestep, step, true) -- коордмастер к переодеванию
end

function rabota_benzp() -- функция что-бы купить бензопилу
	printm("Бежим брать бензопилу за 200 вирт!")
	benzp = 1
	razdv = 3
	coordStart(-535.08825683594, -182.17347717285, 78.430854797363, timestep, step, true) -- коордмастер к бензопиле
end

function rabota_delatdengi() -- функция что-бы начать рубить дерево
	printm("Бежим делать бабосики!")
	benzp = 3
	derevo = 0
	rabota_zrobitibablo()
end

function rabota_zdatdervo() -- функция что-бы сдать бревно
	printm("Бежим сдавать бревно")
	coordStart(-512.45080566406, -190.89691162109, 78.257202148438, timestep, step, true) -- коордмастер к сдаче бревна
end

function rabota_zrobitibablo() -- функция что-бы находить дерево (самое последнее, лень было делать чтоб самое ближнее) и копать его
	for k, v in pairs(getAllLabels()) do
		if v.text:find("Срубить") then
			x = v.position.x
			y = v.position.y
			z = v.position.z
		end
	end
	coordStart(x, y, z, timestep, step, true)
	derevo = 1
end

function onLoad() -- функция которая начинается при запуске скрипта
	printm("Успешно загружен. By Haymiritch")
	
	newTask(function()
		while true do -- цикл бота
			if ustr == 1 then
				ustr = 2
				rabota_ustr()				
			end			
			if benzp == 2 then
				rabota_delatdengi()
			end
			wait(1000)
		end
	end)
end

function onPrintLog(text) -- хуки на текст
	if text:find("Используйте команду") then
		ustr = 1
	end
	if text:find("рабочий день") then
		rabota_razdv() 
	end	
	if text:find("спилено дерева:") then
		derevo = 0
		rabota_zrobitibablo()
	end
	if text:find("переоделись в рабочую одежду") then
		rabota_benzp()
	end	
end

function sampev.onShowDialog(id, style, title, btn1, btn2, text) -- функция для управления диалогами
    if title:find("Лесопилка") then -- устраиваемся на работу (и не устраиваемся)
        sendDialogResponse(id, 1, 0, "")
		return false
    end
	if title:find("работу") then -- смотрим, надо ли устраиватся на работу
		if text:find("устроиться") then -- если НАДО устроится
			sendDialogResponse(id, 1, -1, "")
			ustr = 4
			return false
		else
			sendDialogResponse(id, 0, -1, "") -- если НЕ НАДО устроится
			ustr = 4
			return false
		end
    end
	if title:find("Информация") then -- не нужный текст который следует закрыть
        sendDialogResponse(id, 1, -1, "")
        return false
    end
	if title:find("Раздевалка") then -- переодеваемся
		if text:find("обычную") then
			sendDialogResponse(id, 0, -1, "")
			return false
		else
			sendDialogResponse(id, 1, -1, "")
			return false
		end       
    end
	if title:find("бензопилы") then -- покупаем бензопилу
        sendDialogResponse(id, 1, -1, "")
		benzp = 2
        return false
    end
	
	if title:find('Пароль') then -- это и ниже нужно для авто регистрации/входа
        sendDialogResponse(id, 1, 0, password)
        return false
    end
    if title:find('Выберите ваш пол') then
		sendDialogResponse(id, 1, 0, "")
        return false
    end
	if title:find('Выберите цвет кожи') then
		sendDialogResponse(id, 1, 0, "")
        return false
    end
	if title:find('вы о нас узнали?') then
		sendDialogResponse(id, 1, 1, "")
        return false
	end
	if title:find('Введите ник пригласившего?') then
		sendDialogResponse(id, 1, 0, referal)
        return false
	end
	if title:find('Дополнительная') then
		sendDialogResponse(id, 0, 0, "")
		return false
	end	
	if title:find('Авторизация') then
		sendDialogResponse(id, 1, 0, password)
		return false
	end
end

function sampev.onShowTextDraw(id, data) -- для управления текстдравами
	if id == 419 then
		newTask(function()
			wait(1000)
			sendClickTextdraw(id)
		end)
	end
end

function sendKey(id) -- для симуляции нажатий кнопок
    key = id
    updateSync()
end

function sampev.onSendPlayerSync(data) -- для симуляции нажатий кнопок
    if key then
        data.keysData = key
        key = nil
    end
end

function onSendRPC(id, bs) -- для регистрации
	if id == 128 then
		return true
	end
end

function onRunCommand(cmd) -- комманды
    if cmd:find("^!key %d+$") then
        sendKey(tonumber(cmd:match("%d+")))
        return false
    end
	if cmd == "!razdevalka" then
		printm("Летим переодеватся (вручную)")
		coordStart(-535.1162109375, -175.99670410156, 78.430854797363, timestep, step, true)
	end
	if cmd == "!benzopila" then
		printm("Летим покупать бензопилу (вручную)")
		coordStart(-535.08825683594, -182.17347717285, 78.430854797363, timestep, step, true)
	end
	if cmd == "!sdatbrevno" then
		printm("Летим сдавать бревно (вручную)")
		coordStart(-512.45080566406, -190.89691162109, 78.257202148438, timestep, step, true)
	end
	if cmd == "!rabotadnepr" then
		printm("Летим рубить бревно (вручную)")
		rabota_zrobitibablo()
	end
end

-- устроится на работу -554.31585693359, -173.51475524902, 78.430854797363
-- раздевалка -535.1162109375, -175.99670410156, 78.430854797363
-- взять бензопилу (200 вирт) -535.08825683594, -182.17347717285, 78.430854797363
-- сдать дерево (нажать альт) -512.45080566406, -190.89691162109, 78.257202148438