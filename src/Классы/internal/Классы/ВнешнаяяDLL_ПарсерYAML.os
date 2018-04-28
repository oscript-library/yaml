#Использовать logos
#Использовать semver

Перем Лог;

#Область ПрограммныйИнтерфейс

// YAML Парсер
//
// Параметры:
//  Значение - Строка - Строка данных в формате YAML для парсинга;
//
// Возвращаемое значение:
//  Соответсвие - Набор данных согласно содержимому входящих данных. 
//
Функция ПрочитатьYAML(Знач Значение) Экспорт

	ПроцессорЧтения = Новый YamlПроцессорYamlDotNet;

	Возврат ПроцессорЧтения.ПрочитатьYaml(Значение);

КонецФункции

// YAML сериализатор
//
// Параметры:
//  Значение - Произвольный - Набор данных сериализуемых в формат;
//
// Возвращаемое значение:
//  Строка - Строка данных в формате YAML согласно содержимому входящих данных. 
//
Функция ЗаписатьYAML(Знач Значение) Экспорт
	
	ВызватьИсключение "Функционал записи yaml не реализован";

	ПроцессорЗаписи = Новый YamlПроцессорYamlDotNet;

	Возврат ПроцессорЗаписи.ЗаписатьYAML(Значение);

КонецФункции

Процедура ПриСозданииОбъекта()

	ПодключитьDLL();

КонецПроцедуры

#КонецОбласти

#Область Упакованные_dll

Процедура РаспаковатьДанныеDLL(Знач ПутьКФайлу, ДанныеDLL)
	
	ДвоичныеДанные = Base64Значение(ДанныеDLL.ДвоичныеДанные());
	
	ОбеспечитьКаталог(ПутьКФайлу);
		
	ДвоичныеДанные.Записать(ПутьКФайлу);

КонецПроцедуры

Функция ВычислитьХешФайла(Знач ПутьКФайлу)

	ХешФайла = Новый ХешированиеДанных(ХешФункция.MD5);
	ХешФайла.ДобавитьФайл(ПутьКФайлу);

 	Возврат ХешФайла.ХешСуммаСтрокой;
	
КонецФункции

Процедура ПодключитьDLL()
	
	ЗапакованныеДанные = ПолучитьДанныеDLL();

	ЧитательYaml = ЗапакованныеДанные.YamlDotNetProcessor;

	Если ЧитательYaml = Неопределено Тогда
		ВызватьИсключение "Не удалось найти библиотеку чтения файлов <yaml>";
	КонецЕсли;	

	НайтиФайлИлиРаспаковать(ЧитательYaml);
	
	ДополнительнаяБиблиотека = ЗапакованныеДанные.YamlDotNet;

	Если ДополнительнаяБиблиотека = Неопределено Тогда
		ВызватьИсключение "Не удалось найти библиотеку чтения файлов <yaml>";
	КонецЕсли;	

	НайтиФайлИлиРаспаковать(ДополнительнаяБиблиотека);

	ПутьКФайлу = ПолучитьПутьКФайлуDLL(ЧитательYaml.ИмяФайла(), ЧитательYaml.Версия());

	ПодключитьВнешнююКомпоненту(ПутьКФайлу);

КонецПроцедуры

Процедура НайтиФайлИлиРаспаковать(ДанныеDLL)
	
	ИмяФайла = ДанныеDLL.ИмяФайла();
	
	ПутьКФайлу = ПолучитьПутьКФайлуDLL(ИмяФайла, ДанныеDLL.Версия());

	ВременныйФайл = Новый Файл(ПутьКФайлу);

	Если Не ВременныйФайл.Существует() 
		Тогда// ИЛИ Не ВычислитьХешФайла(ПутьКФайлу) = ДанныеDll.Хеш() Тогда
		РаспаковатьДанныеDLL(ПутьКФайлу, ДанныеDLL);
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьПутьКФайлуDLL(ИмяФайла, ВерсияФайла)
	ПутьКФайлу = ОбъединитьПути(КаталогВременныхФайлов(), ".yaml", СтрЗаменить(ВерсияФайла, ".", "_"), ИмяФайла);
	Возврат ПутьКФайлу;
КонецФункции

Процедура ОбеспечитьКаталог(ПутьККаталогу)
	
	ВременныйКаталог = Новый Файл(ПутьККаталогу);

	Если ВременныйКаталог.Существует() Тогда
		Возврат;
	КонецЕсли;

	СоздатьКаталог(ВременныйКаталог.Путь);

КонецПроцедуры

Функция ПолучитьДанныеDLL()
	
	СИ = Новый СистемнаяИнформация;
	ТекущаяВерсия = Новый Версия(СИ.Версия);

	ИндексВерсийДЛЛ = Новый Соответствие;
	ИндексВерсийДЛЛ.Вставить("1.0.0", ">=1.0.19");

	МассивПодходящихВерсийДЛЛ = Новый Массив;

	Для каждого ВерсияПроверки Из ИндексВерсийДЛЛ Цикл
		
		ДиапазонСравнения = ВерсияПроверки.Значение;
		ВерсияПроверкиДЛЛ = ВерсияПроверки.Ключ;
		Результат = Версии.ВерсияВДиапазоне(ТекущаяВерсия, ДиапазонСравнения);

		Если Результат Тогда
			МассивПодходящихВерсийДЛЛ.Добавить(ВерсияПроверкиДЛЛ);
		КонецЕсли;

	КонецЦикла;

	ВерсияДЛЛ = Версии.МаксимальнаяИзМассива(МассивПодходящихВерсийДЛЛ);
	
	МенеджерЗапакованныхФайлов = Новый МенеджерЗапакованныхФайлов;

	YamlDotNet = МенеджерЗапакованныхФайлов.ПолучитьКлассФайла("YamlDotNet.dll", ВерсияДЛЛ);
	YamlDotNetProcessor = МенеджерЗапакованныхФайлов.ПолучитьКлассФайла("YamlDotNetProcessor.dll", ВерсияДЛЛ);
	ДанныеDLL = Новый Структура("YamlDotNet, YamlDotNetProcessor", YamlDotNet, YamlDotNetProcessor);

	Возврат ДанныеDLL;

КонецФункции

#КонецОбласти

Лог = Логирование.ПолучитьЛог("oscript.lib.yaml");