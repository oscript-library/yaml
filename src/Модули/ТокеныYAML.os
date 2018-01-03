#Использовать logos

Перем Токены;
Перем КэшРегулярныхВыражений;
Перем Лог;

Функция ПрочитатьТокены(Знач СтрокаYaml) Экспорт

	Игнорировать = Ложь;
	indents = 0;
	lastIndents = 0;
	indentAmount = -1;
	ТокеныСтроки = Новый Массив;

	СтрокаYaml = СокрЛП(СтрЗаменить(СтрокаYaml, Строка(Символы.CR+Символы.LF), Символы.ПС));

	Токен = Неопределено;
	Пока (СтрДлина(СтрокаYaml) > 0) Цикл
		НачальнаяДлина = СтрДлина(СтрокаYaml);
		Лог.Отладка("Длина текущей строки: %1", СтрДлина(СтрокаYaml));
		Лог.Отладка("Текущая строка: %1", СтрокаYaml);
		
		Для каждого КлючТокена Из Токены Цикл
			
			Лог.Отладка("Работаю с токеном %1 регулярка: <%2>", КлючТокена.Ключ, КлючТокена.Значение);
			Токен = ПолучитьТокен(КлючТокена, СтрокаYaml); 
			//Лог.Отладка("Cтрока после regexp: %1", СтрокаYaml);

			Если НЕ Токен = Неопределено Тогда

				Если Токен.Тип = "comment" Тогда
					Игнорировать = Истина;
					Прервать;
				ИначеЕсли Токен.Тип = "indent" Тогда
					
					lastIndents  = indents;

					Если indentAmount = -1 Тогда
						Лог.Отладка("Установлен indentAmount <%1>", СтрДлина(Токен.Значение[1]));
						indentAmount = СтрДлина(Токен.Значение[1]);
					КонецЕсли;

					indents = СтрДлина(Токен.Значение[1]) / indentAmount;
					Лог.Отладка("Cтрока <%1> indents: %2, indentAmount: %3", СтрДлина(Токен.Значение[1]),  indents, indentAmount);

					Если indents = lastIndents Тогда
						Игнорировать = Истина;
					ИначеЕсли indents > lastIndents+1 Тогда
						ВызватьИсключение СтрШаблон("Не верный идентификатор, всего %1 из %2 ", indents, lastIndents + 1);
						// throw new SyntaxError('invalid indentation, got ' + indents + ' instead of ' + (lastIndents + 1))
					ИначеЕсли indents < lastIndents Тогда	
					
						ДопЗначение = СтрокаYaml;
						Токен = НовыйТокен("dedent");
						Токен.ДопЗначение = ДопЗначение;

						Пока lastIndents > indents Цикл
							ТокеныСтроки.Добавить(Токен);
							lastIndents = lastIndents - 1;
						КонецЦикла;

						lastIndents = indents;
					КонецЕсли; 

				КонецЕсли;
				Прервать; 	
			КонецЕсли;
		
		КонецЦикла;
		
		Лог.Отладка("Установлен Игнорировать <%1>", Игнорировать);
						
		Если НЕ Игнорировать Тогда
			Если НЕ Токен = Неопределено Тогда
				ТокеныСтроки.Добавить(Токен);
				Токен = Неопределено;
			
			Иначе 
				ВызватьИсключение "Ошибка парсинга токенов строки";//throw new SyntaxError(context(str))
			КонецЕсли; 
	
		КонецЕсли;
		Игнорировать = Ложь;
		// Если НачальнаяДлина = СтрДлина(СтрокаYaml) Тогда
		// 	Прервать;
		// КонецЕсли;
	КонецЦикла;

	Возврат ТокеныСтроки;

КонецФункции


Функция ПолучитьТокен(Токен, Строка)
	Регулярка = КэшРегулярныхВыражений[Токен.Значение];
	Если  Регулярка = Неопределено Тогда
		Регулярка = Новый РегулярноеВыражение(Токен.Значение);
		Регулярка.Многострочный = Ложь;
		КэшРегулярныхВыражений.Вставить("Токен.Значение", Регулярка);
	КонецЕсли;

	КоллекцияСовпадений = Регулярка.НайтиСовпадения(Строка);

	Если КоллекцияСовпадений.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	Лог.Отладка("Количество: %1 совпадений для %2", КоллекцияСовпадений.Количество(), Токен.Значение);
	МассивЗначений = Новый Массив;

	Для каждого Совпадение Из КоллекцияСовпадений Цикл
		
		Лог.Отладка("Добавляю: <%1> совпадений для %2", Совпадение.Значение, Токен.Значение);
		МассивЗначений.Добавить(Совпадение.Значение);
		
		Для каждого ГруппаСовпадений Из Совпадение.Группы Цикл
			МассивЗначений.Добавить(ГруппаСовпадений.Значение);
		КонецЦикла;
	
	КонецЦикла;
	
	Строка = Регулярка.Заменить(Строка, "");
	
	Возврат НовыйТокен(Токен.Ключ, МассивЗначений);

КонецФункции

Функция НовыйТокен(ТипТокена, ЗначениеТокена = "")

	Возврат новый Структура("Тип, Значение, ДопЗначение", ТипТокена, ЗначениеТокена);
	
КонецФункции

Процедура Инициализация()
	
	Токены = Новый Соответствие;
	Токены.Вставить("comment", "^#[^\n]*");
	Токены.Вставить("indent", "^\n( *)");
	Токены.Вставить("space", "^\s+");
	Токены.Вставить("true", "^\b(enabled|true|yes|on)\b");
	Токены.Вставить("false", "^\b(disabled|false|no|off)\b");
	Токены.Вставить("null", "^\b(null|Null|NULL|~)\b");
	Токены.Вставить("timestamp", "^((\d{4})-(\d\d?)-(\d\d?)(?:(?:[ \t]+)(\d\d?):(\d\d)(?::(\d\d))?)?)");
	Токены.Вставить("float", "^(\d+\.\d+)");
	Токены.Вставить("int", "^(\d+)");
	Токены.Вставить("doc", "^---");
	Токены.Вставить(",", "^,");
	Токены.Вставить("{", "^\{(?![^\n\}]*\}[^\n]*[^\s\n\}])");
	Токены.Вставить("}", "^\}");
	Токены.Вставить("[", "^\[(?![^\n\]]*\][^\n]*[^\s\n\]])");
	Токены.Вставить("]", "^\]");
	Токены.Вставить("-", "^\-");
	Токены.Вставить(":", "^[:]");
	Токены.Вставить("string", "^""(.*?)""");
	Токены.Вставить("string", "^'(.*?)'");
	Токены.Вставить("string", "^(?![^#:\n\s]*:[^\/]{2})(([^#:,\]\}\n\s]|(?!\n)\s(?!\s*?\n)|:\/\/|,(?=[^\n]*\s*[^\]\}\s\n]\s*\n)|[\]\}](?=[^\n]*\s*[^\]\}\s\n]\s*\n))*)(?=[,:\]\}\s\n]|$)"); 
	Токены.Вставить("id", "^([\w][\w -]*)");

	КэшРегулярныхВыражений = Новый Соответствие;

	Лог = Логирование.ПолучитьЛог("oscript.lib.yaml_tokens");
	Лог.УстановитьУровень(УровниЛога.Отладка)
КонецПроцедуры

Инициализация();