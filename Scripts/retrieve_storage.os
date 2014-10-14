﻿
Перем мНастройки;
Перем мКаталогСборки;
Перем мПараметрыДоступаКБазе;
Перем мПараметрыДоступаКХранилищу;

Процедура ПрочитатьНастройки()
	
	ТекстАргументов = "";
	Для Сч = 0 По АргументыКоманднойСтроки.Количество()-1 Цикл
		ТекстАргументов = ТекстАргументов + Символы.ПС + " - " + АргументыКоманднойСтроки[Сч];
	КонецЦикла;
	
	СообщениеСборки("Запущено с параметрами:" + ТекстАргументов);
	
	Если АргументыКоманднойСтроки.Количество() < 3 Тогда
		Сообщить("Некорректно заданы аргументы командной строки");
		Сообщить("Требуется задать:");
		Сообщить("<ПутьК1С> <КаталогХранилища> <ПользовательХранилища> [ПарольХранилища]");
		ЗавершитьРаботу(1);
	КонецЕсли;
	
	мНастройки = Новый Структура;
	мНастройки.Вставить("ПутьК1С", """" + АргументыКоманднойСтроки[0] + """");
	мНастройки.Вставить("КаталогХранилища", АргументыКоманднойСтроки[1]);
	мНастройки.Вставить("ПользовательХранилища", АргументыКоманднойСтроки[2]);
	Если АргументыКоманднойСтроки.Количество() >= 4 Тогда
		мНастройки.Вставить("ПарольХранилища", АргументыКоманднойСтроки[3]);
	Иначе
		мНастройки.Вставить("ПарольХранилища" ,"");
	КонецЕсли;
	
	ФайлСкрипта = Новый Файл(ТекущийСценарий().Источник);
	
	мКаталогСборки = ФайлСкрипта.Путь + "v8Temp";
	ОбеспечитьКаталог(мКаталогСборки);
	
	СообщениеСборки("Каталог сборки: " + мКаталогСборки);
	
	мПараметрыДоступаКБазе = Новый Массив;
	мПараметрыДоступаКБазе.Добавить("DESIGNER");
	мПараметрыДоступаКБазе.Добавить("/F""" + ПутьКВременнойБазе() + """");
	мПараметрыДоступаКБазе.Добавить("/Out""" + ФайлИнформации() + """");
	
	мПараметрыДоступаКХранилищу = СкопироватьМассив(мПараметрыДоступаКБазе);
	мПараметрыДоступаКХранилищу.Добавить("/DisableStartupMessages");
	мПараметрыДоступаКХранилищу.Добавить("/DisableStartupDialogs");
	мПараметрыДоступаКХранилищу.Добавить("/ConfigurationRepositoryF """+мНастройки.КаталогХранилища+"""");
	мПараметрыДоступаКХранилищу.Добавить("/ConfigurationRepositoryN """+мНастройки.ПользовательХранилища+"""");
	Если Не ПустаяСтрока(мНастройки.ПарольХранилища) Тогда
		мПараметрыДоступаКХранилищу.Добавить("/ConfigurationRepositoryP """+мНастройки.ПарольХранилища+"""");
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбеспечитьКаталог(Знач Каталог)

	Файл = Новый Файл(Каталог);
	Если НЕ Файл.Существует() Тогда
		СоздатьКаталог(Каталог);
	ИначеЕсли Не Файл.ЭтоКаталог() Тогда
		ВызватьИсключение "Каталог " + Каталог + " не является каталогом";
	КонецЕсли;

КонецПроцедуры

Функция СкопироватьМассив(Источник)
	
	НовыйМассив = Новый Массив;
	Для Каждого Элемент Из Источник Цикл
		НовыйМассив.Добавить(Элемент);
	КонецЦикла;
	
	Возврат НовыйМассив;
	
КонецФункции

Функция ЗапуститьИПодождать(Параметры)

	СтрокаЗапуска = "";
	Для Каждого Параметр Из Параметры Цикл
	
		СтрокаЗапуска = СтрокаЗапуска + " " + Параметр;
	
	КонецЦикла;

	КодВозврата = 0;
	
	Сообщить(мНастройки.ПутьК1С + СтрокаЗапуска);
	
	ЗапуститьПриложение(мНастройки.ПутьК1С + СтрокаЗапуска, , Истина, КодВозврата);
	
	Возврат КодВозврата;

КонецФункции

Функция ФайлИнформации()
	Возврат мКаталогСборки + "\log.txt";
КонецФункции

Функция ПутьКВременнойБазе()
	Возврат мКаталогСборки + "\TempDB";
КонецФункции

Процедура ВывестиФайлИнформации()

	Файл = Новый Файл(ФайлИнформации());
	Если Файл.Существует() Тогда
		Чтение = Новый ЧтениеТекста(Файл.ПолноеИмя);
		Сообщение = Чтение.Прочитать();
		Сообщить(Сообщение);
		Чтение.Закрыть();
	Иначе
		Сообщить("Информации об ошибке нет");
	КонецЕсли;

КонецПроцедуры

Процедура СообщениеСборки(Знач Сообщение)

	Сообщить(Строка(ТекущаяДата()) + " " + Сообщение);
	
КонецПроцедуры

Функция ПараметрыВременнойБазы()

	ПараметрыВремБазы = СкопироватьМассив(мПараметрыДоступаКБазе);
	ПараметрыВремБазы[1] = "/F""" + ПутьКВременнойБазе() + """";
	ПараметрыВремБазы.Удалить(2);
	
	Возврат ПараметрыВремБазы;

КонецФункции

Процедура СоздатьВременнуюБазу()

	СообщениеСборки("Создание временной базы для запуска Конфигуратора");
	КаталогВременнойБазы = ПутьКВременнойБазе();
	ОбеспечитьКаталог(КаталогВременнойБазы);
	УдалитьФайлы(КаталогВременнойБазы, "*.*");
	
	ПараметрыЗапуска = Новый Массив;
	ПараметрыЗапуска.Добавить("CREATEINFOBASE");
	ПараметрыЗапуска.Добавить("File="""+КаталогВременнойБазы+""";");
	//ПараметрыЗапуска.Добавить("/Out""" + ФайлИнформации() + """");
	
	КодВозврата = ЗапуститьИПодождать(ПараметрыЗапуска);
	Если КодВозврата = 0 Тогда
		СообщениеСборки("Временная база создана");
	Иначе
		СообщениеСборки("Не удалось создать временную базу:");
		ВывестиФайлИнформации();
		ЗавершитьРаботу(1);
	КонецЕсли;

КонецПроцедуры

Процедура ПолучитьВерсиюИзХранилища()

	ПараметрыПолучитьВерсию = СкопироватьМассив(мПараметрыДоступаКХранилищу);
	ПараметрыПолучитьВерсию.Добавить("/ConfigurationRepositoryDumpCfg """+мКаталогСборки+"\source.cf""");

	СообщениеСборки("Получение версии из хранилища");
	КодВозврата = ЗапуститьИПодождать(ПараметрыПолучитьВерсию);
	Если КодВозврата = 0 Тогда
		СообщениеСборки("Версия получена");
	Иначе
		СообщениеСборки("Не удалось получить версию из хранилища:");
		ВывестиФайлИнформации();
		ЗавершитьРаботу(1);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьПоявлениеВерсии()
	
	СообщениеСборки("Проверка существования файла версии");
	
	ФайлВерсии = Новый Файл(мКаталогСборки + "\source.cf");
	Если Не ФайлВерсии.Существует() Тогда
		ВызватьИсключение "Файл с актуальной версией не обнаружен";
	КонецЕсли;
	
	СообщениеСборки("Файл версии создан");
	
КонецПроцедуры

Процедура ОбновитьКонфигурациюИзХранилища()

	ДополнитьНастройки();
	
	КоманднаяСтрокаРабочейБазы = мНастройки.ИмяСервера + "\" + мНастройки.ИмяБазы;
	
	ПараметрыСвязиСБазой = Новый Массив;
	ПараметрыСвязиСБазой.Добавить("DESIGNER");
	ПараметрыСвязиСБазой.Добавить("/S""" + КоманднаяСтрокаРабочейБазы + """");
	ПараметрыСвязиСБазой.Добавить("/N""" + мНастройки.АдминистраторБазы + """");
	ПараметрыСвязиСБазой.Добавить("/P""" + мНастройки.ПарольАдминистратораБазы + """");
	ПараметрыСвязиСБазой.Добавить("/UC""" + мНастройки.ПарольАдминистратораБазы + """");
	
	Для Сч = 2 По мПараметрыДоступаКХранилищу.Количество() - 1 Цикл
		Параметр = мПараметрыДоступаКХранилищу[Сч];
		ПараметрыСвязиСБазой.Добавить(Параметр);
	КонецЦикла;
	
	ПараметрыСвязиСБазой.Добавить("/ConfigurationRepositoryUpdateCfg -force -revised");
	
	СообщениеСборки("Обновление конфигурации из хранилища");
	КодВозврата = ЗапуститьИПодождать(ПараметрыСвязиСБазой);
	Если КодВозврата = 0 Тогда
		СообщениеСборки("Конфигурация обновлена");
	Иначе
		СообщениеСборки("Не удалось обновить конфигурацию из хранилища:");
		ВывестиФайлИнформации();
		ЗавершитьРаботу(1);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнитьНастройки()

	СИ = Новый СистемнаяИнформация();
	
	Окружение = СИ.ПеременныеСреды();
	
	// Параметры сервера
	мНастройки.Вставить("ИмяСервера", Окружение["server_host"]);
	мНастройки.Вставить("АдминистраторКластера", Окружение["cluster_admin"]);
	мНастройки.Вставить("ПарольАдминистратораКластера", Окружение["cluster_admin_password"]);
	мНастройки.Вставить("КлассCOMСоединения", Окружение["com_connector"]);
	мНастройки.Вставить("АдминистраторКластера", Окружение["cluster_admin"]);
	
	// Параметры рабочей базы
	мНастройки.Вставить("ИмяБазы", Окружение["db_name"]);
	мНастройки.Вставить("АдминистраторБазы", Окружение["db_user"]);
	мНастройки.Вставить("ПарольАдминистратораБазы", Окружение["db_password"]);
	
КонецПроцедуры

ПрочитатьНастройки();
// CICD-54
//СоздатьВременнуюБазу();
//ПолучитьВерсиюИзХранилища();
//ПроверитьПоявлениеВерсии();
ОбновитьКонфигурациюИзХранилища();


