//    Copyright 2018 khorevaa
// 
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
// 
//        http://www.apache.org/licenses/LICENSE-2.0
// 
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.

#Использовать logos
#Использовать semver

Перем Лог; // Класс из logos

Перем РефлекторПроверки; // Рефлектор
Перем ОбъектПроверки; // КлассОбъект
Перем ТаблицаМетодов; // ТаблицаЗначений
Перем ТаблицаСвойств; // ТаблицаЗначений

Перем ИндексКешаТипов; // Соответствие

Перем Сброс; // Булево
Перем ВерсияБольше20; // булево

Процедура ПриСозданииОбъекта(НовыйОбъектПроверки = Неопределено)

	ОбъектПроверки = НовыйОбъектПроверки;

	РефлекторПроверки = Новый Рефлектор;
	ИндексКешаТипов = Новый Соответствие;
	Сброс = Истина;

	Версия20 = Новый Версия("1.0.20");

	СИ = Новый СистемнаяИнформация;
	ТекущаяВерсия = Новый Версия(СИ.Версия);
	ВерсияБольше20 = ТекущаяВерсия.БольшеИлиРавны(Версия20);

	Лог.Отладка("Версия oscript: <%1>", ТекущаяВерсия.ВСтроку());

КонецПроцедуры

// Устанавливает объект проверки для рефлектора
//
// Параметры:
//   НовыйОбъектПроверки - Объект, Произвольный - объект для проверки
//
Процедура УстановитьОбъект(НовыйОбъектПроверки) Экспорт

	ОбъектПроверки = НовыйОбъектПроверки;
	Сброс = Истина;

КонецПроцедуры

// Выполняет проверку на наличии у объекта функции
//
// Параметры:
//   ИмяФункции - Строка - имя проверяемой функции
//   КоличествоПараметров - Число - количество требуемых параметров
//
// Возвращаемое значение:
//   булево - Истина, если функция существует
//
Функция ЕстьФункция(ИмяФункции, КоличествоПараметров = 0) Экспорт

	Возврат ПроверитьМетодКласса(ИмяФункции, КоличествоПараметров, Истина);

КонецФункции

// Выполняет проверку на наличии у объекта процедуры
//
// Параметры:
//   ИмяПроцедуры - Строка - имя проверяемой процедуры
//   КоличествоПараметров - Число - количество требуемых параметров
//
// Возвращаемое значение:
//   булево - Истина, если процедура существует
//
Функция ЕстьПроцедура(ИмяПроцедуры, КоличествоПараметров = 0) Экспорт

	Возврат ПроверитьМетодКласса(ИмяПроцедуры, КоличествоПараметров);

КонецФункции

// Выполняет проверку на обязательность процедуры у объекта
// Вызывает исключение, в случае отсутствия
//
// Параметры:
//   ИмяПроцедуры - Строка - имя проверяемой процедуры
//   КоличествоПараметров - Число - количество требуемых параметров
//
Процедура ОбязательнаяПроцедура(ИмяПроцедуры, КоличествоПараметров = 0) Экспорт

	Если НЕ ЕстьПроцедура(ИмяПроцедуры, КоличествоПараметров) Тогда
		Лог.КритичнаяОшибка("Класс <%1> не реализует обязательной процедуры <%2> c количеством параметров <%3>",
							ОбъектПроверки,
							ИмяПроцедуры,
							КоличествоПараметров);
		ВызватьИсключение "Ошибка проверки обязательной процедуры";
	КонецЕсли;

КонецПроцедуры

// Выполняет проверку на обязательность функции у объекта
// Вызывает исключение, в случае отсутствия
//
// Параметры:
//   ИмяФункции - Строка - имя проверяемой функции
//   КоличествоПараметров - Число - количество требуемых параметров
//
Процедура ОбязательнаяФункция(ИмяФункции, КоличествоПараметров = 0) Экспорт

	Если НЕ ЕстьФункция(ИмяФункции, КоличествоПараметров) Тогда
		Лог.КритичнаяОшибка("Класс <%1> не реализует обязательной функции <%2> c количеством параметров <%3>",
							ОбъектПроверки,
							ИмяФункции,
							КоличествоПараметров);
		ВызватьИсключение "Ошибка проверки обязательной процедуры";
	КонецЕсли;

КонецПроцедуры

// Выполняет проверку, что объект реализует требуемый интерфейс класса
//
// Параметры:
//   Интерфейс - Объект.ИнтерфейсОбъекта - ссылка на класс ИнтерфейсОбъекта
//   ВызватьИсключениеРеализации - Булево - признак необходимости вызова исключения при проверке. (по умолчанию <ложь>)
//
//  Возвращаемое значение:
//   булево - Истина, если интерфейс реализован
//
Функция РеализуетИнтерфейс(Интерфейс, ВызватьИсключениеРеализации = Ложь) Экспорт

	Если Сброс Тогда
		ПрочитатьТаблицыОбъекта();
	КонецЕсли;

	ИнтерфейсРеализован = Интерфейс.Реализован(ТаблицаМетодов, ВызватьИсключениеРеализации);

	Если Не ИнтерфейсРеализован
		И ВызватьИсключениеРеализации Тогда
		Лог.КритичнаяОшибка("Класс <%1> не реализует интерфейс <%2>",
							ОбъектПроверки,
							Интерфейс);
		ВызватьИсключение "Не реализован требуемый интерфейс";
	КонецЕсли;

	Возврат ИнтерфейсРеализован;

КонецФункции

// Возвращает реализованные методы согласно интерфейсу класса
//
// Параметры:
//   Интерфейс - Объект.ИнтерфейсОбъекта - ссылка на класс ИнтерфейсОбъекта
//
//  Возвращаемое значение:
//   Структура - набор методов класса с признаком реализации
//    * Ключ - Строка - имя метода
//    * Значение - Булево - Истина, есть метод реализован, иначе Ложь
//
Функция РеализованныеМетодыИнтерфейса(Интерфейс) Экспорт

	Если Сброс Тогда
		ПрочитатьТаблицыОбъекта();
	КонецЕсли;

	Возврат Интерфейс.РеализованныеМетоды(ТаблицаМетодов);

КонецФункции

// Выполняет проверку на наличии у объекта свойства
// Только для версии OneScript 1.0.20 и выше
//
// Параметры:
//   ИмяСвойства - Строка - имя проверяемого свойства
//
// Возвращаемое значение:
//   булево - Истина, если свойство существует
//
Функция ЕстьСвойство(Знач ИмяСвойства) Экспорт

	Возврат ПроверитьСвойствоКласса(ИмяСвойства);

КонецФункции

// Возвращает прочитанную таблицу методов объекта
//
// Параметры:
//   АннотацияФильтр - Строка - аннотация метода для использования фильтра
//   ТолькоЭкспортные - Булево - получать только экспортные методы. Для версии OneScript меньше 1.0.21 игнорируется
//
//  Возвращаемое значение:
//   ТаблицаЗначений - таблица содержащая экспортные методы объекта, доступны следующие колонки
//    * Имя                  - Строка - имя метода объекта
//    * КоличествоПараметров - Число  - число параметров в методе
//    * ЭтоФункция           - Булево - признак, что метод является функцией
//    * Экспорт              - Булево - признак, что метод экспортный
//    Для версии OneScript 1.0.20 и выше доступны дополнительные колонки:
//    * Аннотации            - Неопределено, ТаблицаЗначений - Таблица аннотаций со следующими колонками
//       * Имя       - строка - имя аннотации
//       * Параметры - Неопределено, ТаблицаЗначений - таблица параметров аннотации
//          * Имя      - строка - имя параметра аннотации
//          * Значение - строка - значение параметра аннотации
//    * Параметры            - Неопределено, ТаблицаЗначений - Таблица параметров в методе
//       * Имя                     - Строка - Имя параметра
//       * ПоЗначению              - Булево - Признак наличия значения по умолчанию
//       * ЕстьЗначениеПоУмолчанию - Булево - Признак наличия значения по умолчанию
//       * Аннотации               - Неопределено, ТаблицаЗначений - Таблица аннотаций со следующими колонками
//          * Имя       - строка - имя аннотации
//          * Параметры - Неопределено, ТаблицаЗначений - таблица параметров аннотации
//             * Имя      - строка - имя параметра аннотации
//             * Значение - строка - значение параметра аннотации
//
Функция ПолучитьТаблицуМетодов(АннотацияФильтр = Неопределено, ТолькоЭкспортные = Истина) Экспорт

	Если Сброс Тогда
		ПрочитатьТаблицыОбъекта();
	КонецЕсли;

	Если АннотацияФильтр = Неопределено Тогда
		ВозвращаемоеЗначение = ТаблицаМетодов.Скопировать();
	Иначе
		ВозвращаемоеЗначение = ФильтроватьТаблицуПоАннотациям(ТаблицаМетодов, АннотацияФильтр);
	КонецЕсли;
	
	Если ТолькоЭкспортные Тогда
		ВозвращаемоеЗначение = ВозвращаемоеЗначение.Скопировать(Новый Структура("Экспорт", Истина));
	КонецЕсли;

	Возврат ВозвращаемоеЗначение;

КонецФункции

// Возвращает прочитанную таблицу свойств объекта
// Только для версии OneScript 1.0.20 и выше
//
// Параметры:
//   АннотацияФильтр - Строка - аннотация метода для использования фильтра
//
//  Возвращаемое значение:
//   ТаблицаЗначений - таблица содержащая экспортные свойства объекта, доступны следующие колонки
//    * Имя                  - Строка - имя свойства объекта
//    * Аннотации            - Неопределено, ТаблицаЗначений - Таблица аннотаций со следующими колонками
//       * Имя       - строка - имя аннотации
//       * Параметры - Неопределено, ТаблицаЗначений - таблица параметров аннотации
//          * Имя      - строка - имя параметра аннотации
//          * Значение - строка - значение параметра аннотации
//
Функция ПолучитьТаблицуСвойств(АннотацияФильтр = Неопределено) Экспорт

	Если Сброс Тогда
		ПрочитатьТаблицыОбъекта();
	КонецЕсли;
	
	Если НЕ ВерсияБольше20 Тогда
		Возврат ПустаяТаблицаСвойств();
	КонецЕсли;

	Если АннотацияФильтр = Неопределено Тогда
		Возврат ТаблицаСвойств.Скопировать();
	Иначе
		Возврат ФильтроватьТаблицуПоАннотациям(ТаблицаСвойств, АннотацияФильтр);
	КонецЕсли;

КонецФункции

// Выполняет чтение таблиц объекта
//
// Таблицы:
//
//   ТаблицаМетодов - таблица содержащая экспортные методы объекта, доступны следующие колонки
//    * Имя                  - Строка - имя метода объекта
//    * КоличествоПараметров - Число  - число параметров в методе
//    * ЭтоФункция           - Булево - признак, что метод является функцией
//    * Экспорт              - Булево - признак, что метод экспортный
//    * Аннотации            - Неопределено, ТаблицаЗначений - Таблица аннотаций со следующими колонками
//       * Имя       - строка - имя аннотации
//       * Параметры - Неопределено, ТаблицаЗначений - таблица параметров аннотации
//          * Имя      - строка - имя параметра аннотации
//          * Значение - строка - значение параметра аннотации
//    * Параметры            - Неопределено, ТаблицаЗначений - Таблица параметров в методе
//       * Имя                     - Строка - Имя параметра
//       * ПоЗначению              - Булево - Признак наличия значения по умолчанию
//       * ЕстьЗначениеПоУмолчанию - Булево - Признак наличия значения по умолчанию
//       * Аннотации               - Неопределено, ТаблицаЗначений - Таблица аннотаций со следующими колонками
//          * Имя       - строка - имя аннотации
//          * Параметры - Неопределено, ТаблицаЗначений - таблица параметров аннотации
//             * Имя      - строка - имя параметра аннотации
//             * Значение - строка - значение параметра аннотации
//
//   ТаблицаСвойств - таблица содержащая экспортные свойства объекта, доступны следующие колонки
//    * Имя                  - Строка - имя свойства объекта
//    * Аннотации            - Неопределено, ТаблицаЗначений - Таблица аннотаций со следующими колонками
//       * Имя       - строка - имя аннотации
//       * Параметры - Неопределено, ТаблицаЗначений - таблица параметров аннотации
//          * Имя      - строка - имя параметра аннотации
//          * Значение - строка - значение параметра аннотации
//
Процедура ПрочитатьТаблицыОбъекта()

	Если ОбъектПроверки = Неопределено Тогда
		ТаблицаМетодов = Новый ТаблицаЗначений;
		ТаблицаСвойств = Новый ТаблицаЗначений;
		Возврат;
	КонецЕсли;

	КэшируемыйТип = ?(ТипЗнч(ОбъектПроверки) = Тип("Тип"), ОбъектПроверки, ТипЗнч(ОбъектПроверки));
	СтруктураТаблицИзКеша = ИндексКешаТипов[КэшируемыйТип];

	Если СтруктураТаблицИзКеша = Неопределено Тогда

		ТаблицаМетодов = РефлекторПроверки.ПолучитьТаблицуМетодов(ОбъектПроверки);
		// Аннотации свойств доступны только в типе объекта
		ТаблицаСвойств = РефлекторПроверки.ПолучитьТаблицуСвойств(КэшируемыйТип);

		ОбработатьТаблицаМетодов(ТаблицаМетодов);

		СтруктураТаблицИзКеша = Новый Структура("ТаблицаМетодов, ТаблицаСвойств", ТаблицаМетодов, ТаблицаСвойств);
		ИндексКешаТипов.Вставить(КэшируемыйТип, СтруктураТаблицИзКеша);

	Иначе

		ТаблицаМетодов = СтруктураТаблицИзКеша.ТаблицаМетодов;
		ТаблицаСвойств = СтруктураТаблицИзКеша.ТаблицаСвойств;

	КонецЕсли;

	Сброс = Ложь;

КонецПроцедуры

Функция ПроверитьПоТаблицеМетодов(ИмяМетода, ТребуемоеКоличествоПараметров, ЭтоФункция = Ложь)

	Если Сброс Тогда
		ПрочитатьТаблицыОбъекта();
	КонецЕсли;

	Если ТаблицаМетодов.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;

	СтрокаМетода = ТаблицаМетодов.Найти(ИмяМетода, "Имя");
	Лог.Отладка("Поиск строки в таблице методов класса <%1> найдена: %2, общее количество методов класса: %3",
				ОбъектПроверки,
				НЕ СтрокаМетода = Неопределено,
				ТаблицаМетодов.Количество());
	Если СтрокаМетода = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;

	ПроверкаНаФункцию = ЭтоФункция = СтрокаМетода.ЭтоФункция;
	ПроверкаНаКоличествоПараметров = Ложь;

	Если НЕ ПроверкаНаФункцию Тогда

		Лог.Отладка("Проверяемый метод <%1> проверка на функцию/процедуру: %2", ИмяМетода, ПроверкаНаФункцию);
		Возврат Ложь;

	КонецЕсли;

	Если ВерсияБольше20 Тогда

		ТаблицаПараметров = СтрокаМетода.Параметры;
		ПроверкаНаКоличествоПараметров = ПроверитьКоличествоПараметров(ТаблицаПараметров, ТребуемоеКоличествоПараметров);

	Иначе

		ПроверкаНаКоличествоПараметров = ТребуемоеКоличествоПараметров = СтрокаМетода.КоличествоПараметров;

	КонецЕсли;

	Лог.Отладка("Проверяемый метод <%1> корректен: %2", ИмяМетода, ПроверкаНаФункцию И ПроверкаНаКоличествоПараметров);
	Возврат ПроверкаНаФункцию
		И ПроверкаНаКоличествоПараметров;

КонецФункции

// Возвращает внутренний кеш объектов
//
//  Возвращаемое значение:
//   Соответствие - соответствие внутреннего кеша
//    * Ключ - ОписаниеТипов - для объекта кеширования
//    * Значение - Структура - набор ключей и значений
//       Ключ - Строка - ТаблицаМетодов, ТаблицаСвойств
//       Значение - ТаблицаЗначений - одноименные таблицы значений
//
Функция ПолучитьКешОбъектов() Экспорт
	Возврат ИндексКешаТипов;
КонецФункции

Функция ПустаяТаблицаСвойств()
	
	НоваяТаблицаСвойств = Новый ТаблицаЗначений;
	НоваяТаблицаСвойств.Колонки.Добавить("Имя");
	НоваяТаблицаСвойств.Колонки.Добавить("Аннотации");
	
	Возврат НоваяТаблицаСвойств;

КонецФункции

Функция ПустаяТаблицаАннотаций()
	
	НоваяТаблицаАннотаций = Новый ТаблицаЗначений;
	НоваяТаблицаАннотаций.Колонки.Добавить("Имя");
	НоваяТаблицаАннотаций.Колонки.Добавить("Параметры");
	
	Возврат НоваяТаблицаАннотаций;
	
КонецФункции

Функция ПустаяТаблицаПараметровАннотаций()
	
	НоваяТаблицаАннотаций = Новый ТаблицаЗначений;
	НоваяТаблицаАннотаций.Колонки.Добавить("Имя");
	НоваяТаблицаАннотаций.Колонки.Добавить("Значение");
	
	Возврат НоваяТаблицаАннотаций;
	
КонецФункции

Процедура ОбработатьТаблицаМетодов(ТаблицаМетодовОбъекта)
	
	Если ТаблицаМетодовОбъекта.Колонки.Найти("Аннотации") = Неопределено Тогда
		ТаблицаМетодовОбъекта.Колонки.Добавить("Аннотации");
	КонецЕсли;

	Если ТаблицаМетодовОбъекта.Колонки.Найти("Экспорт") = Неопределено Тогда
		ТаблицаМетодовОбъекта.Колонки.Добавить("Экспорт", Новый ОписаниеТипов("Булево"));
		ТаблицаМетодовОбъекта.ЗаполнитьЗначения(Истина, "Экспорт");
	КонецЕсли;

	ОбработатьПараметры = Истина;
	Если ТаблицаМетодовОбъекта.Колонки.Найти("КоличествоПараметров") = Неопределено  
		ИЛИ ТаблицаМетодовОбъекта.Колонки.Найти("Параметры") = Неопределено Тогда
		ОбработатьПараметры = Ложь;
	КонецЕсли;	
	
	Для Каждого СтрокаТаблицы Из ТаблицаМетодовОбъекта Цикл

		Если СтрокаТаблицы.Аннотации = Неопределено Тогда
			СтрокаТаблицы.Аннотации = ПустаяТаблицаАннотаций();
		КонецЕсли;

		Если ОбработатьПараметры Тогда
			ОбработатьТаблицаМетодов(СтрокаТаблицы.Параметры);
		КонецЕсли;	

		ПривестиТаблицуАннотацийКЕдинообразию(СтрокаТаблицы.Аннотации);

	КонецЦикла;

КонецПроцедуры

Процедура ПривестиТаблицуАннотацийКЕдинообразию(ТаблицаАннотаций)
	
	Если ТаблицаАннотаций = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Аннотация Из ТаблицаАннотаций Цикл
	
		Если Аннотация.Параметры = Неопределено Тогда
			Аннотация.Параметры = ПустаяТаблицаПараметровАннотаций();	
		КонецЕсли;	

		Если НЕ НРег(Аннотация.Имя) = Аннотация.Имя Тогда
			Аннотация.Имя = НРег(Аннотация.Имя);
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

Функция ФильтроватьТаблицуПоАннотациям(ТаблицыДанных, АннотацияФильтр)
	
	ОтфильтрованнаяТаблица = ТаблицыДанных.СкопироватьКолонки();

	Если НЕ ВерсияБольше20 Тогда
		Возврат ОтфильтрованнаяТаблица;
	КонецЕсли;

	Для Каждого СтрокаТаблицы Из ТаблицыДанных Цикл

		Если СтрокаТаблицы.Аннотации = Неопределено Тогда
			Продолжить;
		КонецЕсли;

		Для Каждого Аннотация Из СтрокаТаблицы.Аннотации Цикл
			
			Если НРег(Аннотация.Имя) = Нрег(АннотацияФильтр) Тогда
				НоваяСтрока = ОтфильтрованнаяТаблица.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
			КонецЕсли;

		КонецЦикла;

	КонецЦикла;

	Возврат ОтфильтрованнаяТаблица;

КонецФункции

Функция ПроверитьКоличествоПараметров(ТаблицаПараметров, ТребуемоеКоличествоПараметров)

	ВсегоПараметров = ТаблицаПараметров.Количество();

	Если ВсегоПараметров = ТребуемоеКоличествоПараметров Тогда
		Возврат Истина;
	ИначеЕсли ТребуемоеКоличествоПараметров > ВсегоПараметров Тогда
		Возврат Ложь;
	КонецЕсли;

	ВсегоПараметров = ТаблицаПараметров.Количество();
	КоличествоПараметровНеобязательных = 0;

	Для каждого СтрокаПараметра Из ТаблицаПараметров Цикл
		Если СтрокаПараметра.ЕстьЗначениеПоУмолчанию Тогда
			КоличествоПараметровНеобязательных = КоличествоПараметровНеобязательных + 1;
		КонецЕсли;
	КонецЦикла;

	КоличествоПараметровОбязательных = ВсегоПараметров - КоличествоПараметровНеобязательных;

	Возврат ТребуемоеКоличествоПараметров >= КоличествоПараметровОбязательных
			И ТребуемоеКоличествоПараметров <= ВсегоПараметров;

КонецФункции

Функция ПроверитьСвойствоКласса(Знач ИмяСвойства)

	Если Сброс Тогда
		ПрочитатьТаблицыОбъекта();
	КонецЕсли;

	Если ТаблицаСвойств.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;

	СтрокаСвойства = ТаблицаСвойств.Найти(ИмяСвойства, "Имя");
	Лог.Отладка("Поиск строки в таблице свойств класса <%1> найдена: %2",
				ОбъектПроверки,
				НЕ СтрокаСвойства = Неопределено);
	Если СтрокаСвойства = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;

	Возврат Истина;

КонецФункции

Функция ПроверитьМетодКласса(Знач ИмяМетода, Знач ТребуемоеКоличествоПараметров = 0, Знач ЭтоФункция = Ложь)

	Если ОбъектПроверки = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;

	ПроверяемыйКласс = ОбъектПроверки;

	ЕстьМетод = РефлекторПроверки.МетодСуществует(ПроверяемыйКласс, ИмяМетода);
	Лог.Отладка("Проверяемый метод <%1> найден: %2", ИмяМетода, ЕстьМетод);
	Если Не ЕстьМетод Тогда
		Возврат Ложь;
	КонецЕсли;

	Возврат ПроверитьПоТаблицеМетодов(ИмяМетода, ТребуемоеКоличествоПараметров, ЭтоФункция);

КонецФункции // ПроверитьМетодУКласса()

Лог = Логирование.ПолучитьЛог("oscript.lib.reflector");
