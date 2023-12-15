import 'package:flutter/material.dart';
import 'dart:convert';

class Travel {
  Travel(
    {
      this.id,
      required this.titulo,
      required this.descricao,
      required this.dataInicio,
      required this.dataFim,
      required this.localUrl
    });

    String? id;
    String? titulo;
    String? descricao;
    String? dataInicio;
    String? dataFim;
    String? localUrl;

    factory Travel.fromRawJson(String str) => Travel.fromJson(json.decode(str));

    // Envia os dados para o servidor
    String toRawJson() => json.decode(toJson() as String);

    factory Travel.fromJson(Map<String, dynamic> json) {
      return Travel(
      titulo: json["titulo"],
      descricao: json["descricao"],
      dataInicio: json["dataInicio"],
      dataFim: json["dataFim"],
      localUrl: json["localUrl"],
    );
    }

    Map<String, dynamic> toJson() => {
      "titulo": titulo,
      "descricao": descricao,
      "dataInicio": dataInicio,
      "dataFim": dataFim,
      "localUrl": localUrl,
    };

    Travel copy() => Travel(
      id: id,
      titulo: titulo,
      descricao: descricao,
      dataInicio: dataInicio,
      dataFim: dataFim,
      localUrl: localUrl,
    );  
}