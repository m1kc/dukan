/*
 * parse.d
 *
 * Copyright 2013 m1kc <m1kc@yandex.ru>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 *
 */

import std.stdio;
import std.file;
import std.string;
import std.array;

class Product
{
	string name = "xxx";
	bool allowedInAttack = false;
	bool allowedInCruise = false;
	bool allowedInConsolidation = false;
	bool allowedInStabilization = false;

	override string toString()
	{
		return name ~ " - "
			~ (allowedInAttack?"A":".")
			~ (allowedInCruise?"K":".")
			~ (allowedInConsolidation?"K":".")
			~ (allowedInStabilization?"C":".")
			;
	}

	string toJSON()
	{
		return "{
	name: '" ~ name ~"',
	allowedInAttack: " ~ (allowedInAttack?"true":"false") ~",
	allowedInCruise: " ~ (allowedInCruise?"true":"false") ~",
	allowedInConsolidation: " ~ (allowedInConsolidation?"true":"false") ~",
	allowedInStabilization: " ~ (allowedInStabilization?"true":"false") ~"
}";
	}
}

int main(string[] args)
{
	Product[] products = new Product[0];
	Product current = null;
	foreach(string s; readText("products.html").split("\n"))
	{
		// start
		if (s.indexOf("<tr bgcolor=") != -1)
		{
			current = new Product();
		}
		// name
		if (s.indexOf("<td>") != -1)
		{
			s = s.replace("<td>","").replace("</td>","");
			current.name = s;
		}
		// attack
		if (s.indexOf("<span style=\"color: #ff0000;\"><strong>A</strong></span>") != -1)
		{
			current.allowedInAttack = true;
		}
		if (s.indexOf("<font color=red><b>A</b></font>") != -1)
		{
			current.allowedInAttack = true;
		}
		// cruise
		if (s.indexOf("<span style=\"color: #0000ff;\"><strong>К</strong></span>") != -1)
		{
			current.allowedInCruise = true;
		}
		if (s.indexOf("<font color=blue><b>К</b></font>") != -1)
		{
			current.allowedInCruise = true;
		}
		// consolidation
		if (s.indexOf("<span style=\"color: #008000;\"><strong>K</strong></span>") != -1)
		{
			current.allowedInConsolidation = true;
		}
		if (s.indexOf("<font color=green><b>K</b></font>") != -1)
		{
			current.allowedInConsolidation = true;
		}
		// stabilization
		if (s.indexOf("<span style=\"color: #ffa500;\"><strong>C</strong></span>") != -1)
		{
			current.allowedInStabilization = true;
		}
		if (s.indexOf("<font color=orange><b>C</b></font>") != -1)
		{
			current.allowedInStabilization = true;
		}
		// finish
		if (s.indexOf("</tr>") != -1)
		{
			if (current is null) continue;
			products ~= current;
			current = null;
		}
	}

	foreach(Product p; products)
	{
		//writeln(p.toString());
	}

	writeln("[");
	foreach(Product p; products)
	{
		writeln(p.toJSON(),",");
	}
	writeln("]");

	return 0;
}
