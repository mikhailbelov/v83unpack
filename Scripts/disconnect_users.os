﻿

////////////////////////////////////////////////////////////////////////////
// Основная полезная нагрузка

Функция ОтключитьПользователей()
		
	СоединенияОтключены = Ложь;
	
	Попытка
		Менеджер = Новый МенеджерКластера();
		Дескриптор = Менеджер.ДескрипторУправленияСеансамиБазы();
	Исключение
		СообщениеСборки(ИнформацияОбОшибке().Описание);
		Возврат СоединенияОтключены;
	КонецПопытки;
	
	Попытка
	
		Менеджер.ЗаблокироватьСоединенияСБазой(Дескриптор);
	
		Отладка = Истина;
		Если Отладка Тогда
			ИнтервалОтключения = 100;
		Иначе
			ИнтервалОтключения = 2*60000; // 2 минуты
		КонецЕсли;
		
		МаксимальноеЧислоПопыток = 3;
		ЧислоПопыток = 0;
		Пока ЧислоПопыток < МаксимальноеЧислоПопыток Цикл
			
			Если Менеджер.ЕстьРаботающиеСеансы(Дескриптор, Истина) Тогда
				ЧислоПопыток = ЧислоПопыток + 1;
				СообщениеСборки("Есть работающие сеансы. Ждем " + Цел(ИнтервалОтключения/1000) + " секунд. Попытка №" + Строка(ЧислоПопыток));
				Приостановить(ИнтервалОтключения);
			Иначе
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		Если Менеджер.ЕстьРаботающиеСеансы(Дескриптор, Истина, Ложь) Тогда
			Менеджер.ПрекратитьСуществующиеСеансы(Дескриптор);
		КонецЕсли;
		
		Если Менеджер.ЕстьРаботающиеСеансы(Дескриптор, Истина, Ложь) Тогда
			ВызватьИсключение "Критичный сбой: Сеансы все равно не отключены!";
		КонецЕсли;
		
		СоединенияОтключены = Истина;
	Исключение
		Менеджер.ЗакрытьДескриптор(Дескриптор);
		СообщениеСборки(ИнформацияОбОшибке().Описание);
		СоединенияОтключены = Ложь;
	КонецПопытки;
	
	Менеджер.ЗакрытьДескриптор(Дескриптор);
	СообщениеСборки("Соединения с базой " + Менеджер.Опция("ИмяБазы") + " успешно отключены");
	Возврат СоединенияОтключены;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////
// Служебные процедуры

Процедура СообщениеСборки(Знач Сообщение)

	Сообщить(Строка(ТекущаяДата()) + " " + Сообщение);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////
// Точка входа в скрипт

ПодключитьСценарий("Scripts/cluster_manager.os", "МенеджерКластера");

Если Не ОтключитьПользователей() Тогда
	СообщениеСборки("Отключение не выполнено. См. журнал сообщений");
	ЗавершитьРаботу(1);
КонецЕсли;