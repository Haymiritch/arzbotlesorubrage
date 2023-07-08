-- ����� ���� ������� �� �������������� � �������, �� ����� ��� ���� ��� ��� ��������� ������ ��� �������� ����, ����������
-- �������� �� ������ ��������� �� ��������!!!
-- ���� ������� ������� ����������� �� ����� ����, ��� ���� ����������
-- ����� ������ ����� ������, ������� �������� ��� ���� � ��� � 03 ������ 2023 ����

require("addon") -- �������
local sampev = require("samp.events")

local referal = 'Sam_Mason' -- ��� �������������
local password = '123123123' -- ������ �� �����

local timestep = 50 -- � �������������, �������� ����� ���������� (�� ��������� 50)
local step = 2 -- � ������, ��� ��������� (�� ��������� 2)

local ustr, razdv, benzp, derevo = 0 -- ���� ������ 

--------------------------------------------------------------------------------------

function onCoordStop() -- ������� ����� ���� ��� ����������� ������� ������
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

function printm(text) -- ������� ��� ������ ��������� � ��� � ������
	print("[Lesovoz]: " .. text)
end

function rabota_ustr() -- ������� ���-�� ��������� �� ������ (� �� ���������)
	printm("����� ����������� �� ������!")
	ustr = 3
	coordStart(-554.31585693359, -173.51475524902, 78.430854797363, timestep, step, true) -- ����������� � ����������
end

function rabota_razdv() -- ������� ���-�� ������ �� ���������� � ������ ������
	printm("����� ������������!")
	razdv = 1
	ustr = 5
	coordStart(-535.1162109375, -175.99670410156, 78.430854797363, timestep, step, true) -- ����������� � ������������
end

function rabota_benzp() -- ������� ���-�� ������ ���������
	printm("����� ����� ��������� �� 200 ����!")
	benzp = 1
	razdv = 3
	coordStart(-535.08825683594, -182.17347717285, 78.430854797363, timestep, step, true) -- ����������� � ���������
end

function rabota_delatdengi() -- ������� ���-�� ������ ������ ������
	printm("����� ������ ��������!")
	benzp = 3
	derevo = 0
	rabota_zrobitibablo()
end

function rabota_zdatdervo() -- ������� ���-�� ����� ������
	printm("����� ������� ������")
	coordStart(-512.45080566406, -190.89691162109, 78.257202148438, timestep, step, true) -- ����������� � ����� ������
end

function rabota_zrobitibablo() -- ������� ���-�� �������� ������ (����� ���������, ���� ���� ������ ���� ����� �������) � ������ ���
	for k, v in pairs(getAllLabels()) do
		if v.text:find("�������") then
			x = v.position.x
			y = v.position.y
			z = v.position.z
		end
	end
	coordStart(x, y, z, timestep, step, true)
	derevo = 1
end

function onLoad() -- ������� ������� ���������� ��� ������� �������
	printm("������� ��������. By Haymiritch")
	
	newTask(function()
		while true do -- ���� ����
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

function onPrintLog(text) -- ���� �� �����
	if text:find("����������� �������") then
		ustr = 1
	end
	if text:find("������� ����") then
		rabota_razdv() 
	end	
	if text:find("������� ������:") then
		derevo = 0
		rabota_zrobitibablo()
	end
	if text:find("����������� � ������� ������") then
		rabota_benzp()
	end	
end

function sampev.onShowDialog(id, style, title, btn1, btn2, text) -- ������� ��� ���������� ���������
    if title:find("���������") then -- ������������ �� ������ (� �� ������������)
        sendDialogResponse(id, 1, 0, "")
		return false
    end
	if title:find("������") then -- �������, ���� �� ����������� �� ������
		if text:find("����������") then -- ���� ���� ���������
			sendDialogResponse(id, 1, -1, "")
			ustr = 4
			return false
		else
			sendDialogResponse(id, 0, -1, "") -- ���� �� ���� ���������
			ustr = 4
			return false
		end
    end
	if title:find("����������") then -- �� ������ ����� ������� ������� �������
        sendDialogResponse(id, 1, -1, "")
        return false
    end
	if title:find("����������") then -- �������������
		if text:find("�������") then
			sendDialogResponse(id, 0, -1, "")
			return false
		else
			sendDialogResponse(id, 1, -1, "")
			return false
		end       
    end
	if title:find("���������") then -- �������� ���������
        sendDialogResponse(id, 1, -1, "")
		benzp = 2
        return false
    end
	
	if title:find('������') then -- ��� � ���� ����� ��� ���� �����������/�����
        sendDialogResponse(id, 1, 0, password)
        return false
    end
    if title:find('�������� ��� ���') then
		sendDialogResponse(id, 1, 0, "")
        return false
    end
	if title:find('�������� ���� ����') then
		sendDialogResponse(id, 1, 0, "")
        return false
    end
	if title:find('�� � ��� ������?') then
		sendDialogResponse(id, 1, 1, "")
        return false
	end
	if title:find('������� ��� �������������?') then
		sendDialogResponse(id, 1, 0, referal)
        return false
	end
	if title:find('��������������') then
		sendDialogResponse(id, 0, 0, "")
		return false
	end	
	if title:find('�����������') then
		sendDialogResponse(id, 1, 0, password)
		return false
	end
end

function sampev.onShowTextDraw(id, data) -- ��� ���������� ������������
	if id == 419 then
		newTask(function()
			wait(1000)
			sendClickTextdraw(id)
		end)
	end
end

function sendKey(id) -- ��� ��������� ������� ������
    key = id
    updateSync()
end

function sampev.onSendPlayerSync(data) -- ��� ��������� ������� ������
    if key then
        data.keysData = key
        key = nil
    end
end

function onSendRPC(id, bs) -- ��� �����������
	if id == 128 then
		return true
	end
end

function onRunCommand(cmd) -- ��������
    if cmd:find("^!key %d+$") then
        sendKey(tonumber(cmd:match("%d+")))
        return false
    end
	if cmd == "!razdevalka" then
		printm("����� ������������ (�������)")
		coordStart(-535.1162109375, -175.99670410156, 78.430854797363, timestep, step, true)
	end
	if cmd == "!benzopila" then
		printm("����� �������� ��������� (�������)")
		coordStart(-535.08825683594, -182.17347717285, 78.430854797363, timestep, step, true)
	end
	if cmd == "!sdatbrevno" then
		printm("����� ������� ������ (�������)")
		coordStart(-512.45080566406, -190.89691162109, 78.257202148438, timestep, step, true)
	end
	if cmd == "!rabotadnepr" then
		printm("����� ������ ������ (�������)")
		rabota_zrobitibablo()
	end
end

-- ��������� �� ������ -554.31585693359, -173.51475524902, 78.430854797363
-- ���������� -535.1162109375, -175.99670410156, 78.430854797363
-- ����� ��������� (200 ����) -535.08825683594, -182.17347717285, 78.430854797363
-- ����� ������ (������ ����) -512.45080566406, -190.89691162109, 78.257202148438