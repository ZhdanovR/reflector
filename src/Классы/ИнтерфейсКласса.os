#Использовать logos

Перем КартаИнтерфейса;
Перем Лог;

Процедура ПриСозданииОбъекта()
	
	КартаИнтерфейса = НоваяКартаИнтерфейса();

КонецПроцедуры

Функция Реализован(КартаКласса, СообщитьОшибки = Истина) Экспорт

	ИнтерфейсРеализован = Истина;
	ОшибкиРеализации = "";
	Для каждого Элемент Из КартаИнтерфейса Цикл
		
		НайденныйЭлемент = КартаКласса.Найти(Элемент.Имя, "Имя");
		Если НайденныйЭлемент = Неопределено Тогда
			ИнтерфейсРеализован = Ложь;
			ОшибкиРеализации  = ОшибкиРеализации  + Символы.ВК + Символы.ПС + "Не реализован метод интерфейса " + Элемент.Имя;
			Продолжить;
		КонецЕсли;
		// Сообщить("НайденныйЭлемент: " + НайденныйЭлемент);
		Если НайденныйЭлемент.КоличествоПараметров <> Элемент.КоличествоПараметров Тогда
			ИнтерфейсРеализован = Ложь;
			ОшибкиРеализации  = ОшибкиРеализации  + Символы.ВК + Символы.ПС + "Неверное количество параметров, есть: " 
				+ НайденныйЭлемент.КоличествоПараметров  + " должно быть: " + Элемент.КоличествоПараметров;
		КонецЕсли;
		
	КонецЦикла;

	Если Не ИнтерфейсРеализован
		И СообщитьОшибки Тогда
		Лог.Ошибка(ОшибкиРеализации);
	КонецЕсли;

	Возврат ИнтерфейсРеализован;

КонецФункции

Функция РеализованныеМетоды(КартаКласса) Экспорт

	ИндексМетодов = Новый Структура;

	Для каждого Элемент Из КартаИнтерфейса Цикл
		
		НайденныйЭлемент = КартаКласса.Найти(Элемент.Имя, "Имя");
		Если НайденныйЭлемент = Неопределено Тогда
			ИндексМетодов.Добавить(Элемент.Имя, Ложь);
			Продолжить;
		КонецЕсли;
		Если НайденныйЭлемент.КоличествоПараметров <> Элемент.КоличествоПараметров Тогда
			ИндексМетодов.Добавить(Элемент.Имя, Ложь);
			Продолжить
		КонецЕсли;
		
		ИндексМетодов.Добавить(Элемент.Имя, Истина);
		
	КонецЦикла;

	Возврат ИндексМетодов;
	
КонецФункции

Функция ИзОбъекта(ОбъектИнтерфейса) Экспорт

	Рефлектор = Новый Рефлектор;
	КартаИнтерфейса = Рефлектор.ПолучитьТаблицуМетодов(ОбъектИнтерфейса);
	
КонецФункции

Функция ИзИнтерфейса(ВходящийИнтерфейс, Заменить = Ложь) Экспорт
	
	КартаИнтерфейсаВходящего = ВходящийИнтерфейс.ПолучитьКартуИнтерфейса();

	Если Заменить Тогда
		КартаИнтерфейса = НоваяКартаИнтерфейса();
	КонецЕсли;

	Для каждого СтрокаИнтерфейса Из КартаИнтерфейсаВходящего Цикл
		
		ДобавитьМетод(СтрокаИнтерфейса.Имя, СтрокаИнтерфейса.КоличествоПараметров, СтрокаИнтерфейса.ЭтоФункция)
		
	КонецЦикла;

КонецФункции

Функция ПолучитьКартуИнтерфейса() Экспорт

	Возврат КартаИнтерфейса;
	
КонецФункции

Функция ПроцедураИнтерфейса(ИмяМетода, КоличествоПараметров = 0) Экспорт

	ДобавитьМетод(ИмяМетода, КоличествоПараметров, Ложь);

	Возврат ЭтотОбъект;
	
КонецФункции

Функция ФункцияИнтерфейса(ИмяМетода, КоличествоПараметров = 0) Экспорт

	ДобавитьМетод(ИмяМетода, КоличествоПараметров, Истина);

	Возврат ЭтотОбъект;
	
КонецФункции

Функция П(ИмяМетода, КоличествоПараметров = 0) Экспорт

	ПроцедураИнтерфейса(ИмяМетода, КоличествоПараметров);

	Возврат ЭтотОбъект;
	
КонецФункции

Функция Ф(ИмяМетода, КоличествоПараметров = 0) Экспорт

	ФункцияИнтерфейса(ИмяМетода, КоличествоПараметров);

	Возврат ЭтотОбъект;
	
КонецФункции

Функция НоваяКартаИнтерфейса()

	ТаблицаМетодов = Новый ТаблицаЗначений;
	ТаблицаМетодов.Колонки.Добавить("Имя");
	ТаблицаМетодов.Колонки.Добавить("КоличествоПараметров");
	ТаблицаМетодов.Колонки.Добавить("ЭтоФункция");

	Возврат ТаблицаМетодов;

КонецФункции

Процедура ДобавитьМетод(ИмяМетода, КоличествоПараметров = 0, ЭтоФункция = Ложь)
	
	Отбор = Новый Структура("Имя", ИмяМетода);

	МассивСтрокМетода = КартаИнтерфейса.НайтиСтроки(Отбор);

	Если МассивСтрокМетода.Количество() = 0 Тогда
		СтрокаМетода = КартаИнтерфейса.Добавить();
		СтрокаМетода.Имя = ИмяМетода;
	Иначе
		СтрокаМетода = МассивСтрокМетода[0];
	КонецЕсли;

	СтрокаМетода.КоличествоПараметров = КоличествоПараметров;
	СтрокаМетода.ЭтоФункция = ЭтоФункция;

КонецПроцедуры

Лог = Логирование.ПолучитьЛог("oscript.lib.reflector");